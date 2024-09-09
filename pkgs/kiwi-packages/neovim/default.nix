{ lib, llvmStdenv, callPackage

, fetchFromGitHub

, rustTools
, writeText

, luajit
, neovim-unwrapped

, libiconv
, utf8proc
}:
let
  stdenv = llvmStdenv;

  lua = luajit.override {
    inherit stdenv;

    version = "2.1.ROLLING-unstable-2024-09-04";

    src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "87ae18af97fd4de790bb6c476b212e047689cc93";
      hash = "sha256-HICW9iqXpvS4d3/lyAdeG2QNsNv6tJ6wqRZv9Y7sxe4=";
    };
  };

  utf8proc' = utf8proc.overrideAttrs {
    version = "2.9.0-unstable";

    src = fetchFromGitHub {
      owner = "JuliaStrings";
      repo = "utf8proc";
      rev = "3de4596fbe28956855df2ecb3c11c0bbc3535838";
      hash = "sha256-DNnrKLwks3hP83K56Yjh9P3cVbivzssblKIx4M/RKqw=";
    };
  };

  cmakeGenerateVersion = writeText "GenerateVersion.cmake" ''
    if (NOT EXISTS ''${OUTPUT})
      file(WRITE ''${OUTPUT} "")
    endif ()
  '';

  tree-sitter = callPackage ./deps/tree-sitter.nix {
    inherit (rustTools.rust) rustPlatform;
  };
in (neovim-unwrapped.override {
  inherit stdenv;
  inherit lua tree-sitter;
}).overrideAttrs (final: super: {
  version = "nightly-unstable-2024-09-09";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "648d6426c863c75643d714d45f4b67e19ac6944a";
    hash = "sha256-DPw33pApJk+TmAKIIifWvD9CkLA4io3EtlkOcLtEem0=";
  };

  inherit tree-sitter;

  env.NIX_CFLAGS_COMPILE = toString [
    "-O2" "-march=skylake"
    "-flto=full"
    "-mllvm" "-polly"
    "-mllvm" "-polly-parallel"
    "-mllvm" "-polly-num-threads=8"
  ];
  env.NIX_CFLAGS_LINK = toString [
    "-lgomp"
  ];

  nativeBuildInputs = super.nativeBuildInputs ++ [
    libiconv
    utf8proc'
  ];

  preConfigure = (super.preConfigure or "") + ''
    cp -T ${cmakeGenerateVersion} cmake/GenerateVersion.cmake
    substituteInPlace cmake.config/versiondef.h.in \
      --subst-var-by NVIM_VERSION_PRERELEASE "-${final.version}"
  '';

  cmakeFlags = super.cmakeFlags ++ [
    "-DENABLE_LTO=OFF"
  ];

  meta = super.meta // {
    description = "${super.meta.description} (Kiwi Edition)";
  };
})
