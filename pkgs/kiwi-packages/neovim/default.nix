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

    version = "2.1.ROLLING-unstable-2024-12-16";

    src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "f73e649a954b599fc184726c376476e7a5c439ca";
      hash = "sha256-6BxBYCPWpkHbdsxuoitMcSpcOFvaWEPP4RbJ06SA6Go=";
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
    inherit (rustTools.stable) rustPlatform;

    inherit withWasm wasmtime-c-api;
  };
in (neovim-unwrapped.override {
  inherit stdenv;
  inherit unibilium libuv;
  inherit lua tree-sitter;
}).overrideAttrs (final: super: {
  version = "nightly-unstable-2024-12-20";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "39781be14baff508efd4f99c11786c4228ea2c8d";
    hash = "sha256-p99nX/0U/lg2dEGS3PVhh4GQck0hw+TnOssm1oy9aBA=";
  };

  patches = super.patches or [ ] ++ [
    ./patches/relax-wasmtime-dep.patch
  ];

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
