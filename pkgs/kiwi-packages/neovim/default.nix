{ lib, llvmStdenv, callPackage

, fetchFromGitHub

, rustTools
, writeText

, luajit
, neovim-unwrapped

, libiconv
, libuv
, utf8proc

, buildArch ? null
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

  libuv' = libuv.override {
    inherit stdenv;
  };

  unibilium = callPackage ./deps/unibilium.nix {
    inherit stdenv;
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
  inherit unibilium;
  libuv = libuv';
  inherit lua tree-sitter;
}).overrideAttrs (final: super: {
  version = "nightly-unstable-2024-09-20";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "052e048db676ef3e68efc497c02902e3d43e6255";
    hash = "sha256-Inok0JNRfgHAt9Kddj2TYmoboG7PF6z9jIaxhZy05Ec=";
  };

  inherit tree-sitter;

  env.NIX_CFLAGS_COMPILE = let
    flags = [
      "-O2"
      "-flto=full"
      "-mllvm" "-polly"
      "-mllvm" "-polly-parallel"
      "-mllvm" "-polly-num-threads=8"
    ]
    ++ lib.optional (buildArch != null) "-march=${buildArch}";
  in toString flags;
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
