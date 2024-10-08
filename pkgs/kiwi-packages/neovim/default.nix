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

    version = "2.1.ROLLING-unstable-2024-10-02";

    src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "2240d84464cc3dcb22fd976f1db162b36b5b52d5";
      hash = "sha256-MREC85l6sk/wf7WWbrG97fqPbc7pUXQf7avriJAz9PY=";
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
  version = "nightly-unstable-2024-10-10";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "641c4b1a2acbf4d93142af9799dd13539b6ecde9";
    hash = "sha256-Taz+w0we7D4Y6j7o7Y++iJui/GOrS5EsOmUSu5rtFiI=";
  };

  inherit tree-sitter;

  env.NIX_CFLAGS_COMPILE = let
    flags = [
      "-O2"
      "-flto=full"
      "-mllvm" "-polly"
      "-mllvm" "-polly-omp-backend=LLVM"
      "-mllvm" "-polly-parallel"
      "-mllvm" "-polly-num-threads=0"
      "-mllvm" "-polly-vectorizer=stripmine"
    ]
    ++ lib.optional (buildArch != null) "-march=${buildArch}"
    ++ extraCompileFlags;
  in toString flags;

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
