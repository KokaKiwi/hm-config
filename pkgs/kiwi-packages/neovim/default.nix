{ lib, llvmStdenv, callPackage

, fetchFromGitHub

, rustTools
, writeText

, luajit
, neovim-unwrapped

, libiconv
, utf8proc

, buildArch ? null
, extraCompileFlags ? [ ]
, withWasm ? true
}:
let
  stdenv = llvmStdenv;

  lua = luajit.override {
    inherit stdenv;

    version = "2.1.ROLLING-unstable-2024-09-29";

    src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "f5fd22203eadf57ccbaa4a298010d23974b22fc0";
      hash = "sha256-nGN+D1gIa6h3lHJQIKd5UezbPZsmdUAnsF8bOGjYSuQ=";
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

  libuv = callPackage ./deps/libuv.nix {
    inherit stdenv;
  };

  unibilium = callPackage ./deps/unibilium.nix {
    inherit stdenv;
  };

  wasmtime-c-api = callPackage ./deps/wasmtime-c-api.nix {
    inherit stdenv;
    inherit (rustTools.rust) rustPlatform cargo rustc;
  };

  cmakeGenerateVersion = writeText "GenerateVersion.cmake" ''
    if (NOT EXISTS ''${OUTPUT})
      file(WRITE ''${OUTPUT} "")
    endif ()
  '';

  tree-sitter = callPackage ./deps/tree-sitter.nix {
    inherit stdenv;
    inherit (rustTools.rust) rustPlatform;

    inherit withWasm wasmtime-c-api;
  };
in (neovim-unwrapped.override {
  inherit stdenv;
  inherit unibilium libuv;
  inherit lua tree-sitter;
}).overrideAttrs (final: super: {
  version = "nightly-unstable-2024-09-29";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "20251be15a4ad3f6e7016450ca3338d52b2f0951";
    hash = "sha256-P7a5cu/kHSp0kI2DR048BaEblSvDAlmLsNr9SPa1zI4=";
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
    ++ lib.optional (buildArch != null) "-march=${buildArch}"
    ++ extraCompileFlags;
  in toString flags;
  env.NIX_CFLAGS_LINK = toString [
    "-lgomp"
  ];

  nativeBuildInputs = super.nativeBuildInputs ++ [
    libiconv
    utf8proc'
  ] ++ lib.optionals withWasm [
    wasmtime-c-api
  ];

  preConfigure = (super.preConfigure or "") + ''
    cp -T ${cmakeGenerateVersion} cmake/GenerateVersion.cmake
    substituteInPlace cmake.config/versiondef.h.in \
      --subst-var-by NVIM_VERSION_PRERELEASE "-${final.version}"
  '';

  cmakeFlags = super.cmakeFlags ++ [
    "-DENABLE_LTO=OFF"
  ] ++ lib.optionals withWasm [
    "-DENABLE_WASMTIME=ON"
  ];

  passthru = {
    inherit unibilium libuv wasmtime-c-api;
  };

  meta = super.meta // {
    description = "${super.meta.description} (Kiwi Edition)";
  };
})
