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

    version = "2.1.1724174039";

    src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "304da39cc5ee43491f7b1f4e0c9c52d477ce0d98";
      hash = "sha256-zwkAumd9izV8SW04kEIoWkKbcFbD31277rKYJ8gYKis=";
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
  version = "nightly-unstable-2024-08-21";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "a691858326430d1d5462161fd105aa419d3f54f2";
    hash = "sha256-U5h+NHzayZeAZ6/SVOd11P0GSPpctkCXhiI+YADlD7I=";
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
    utf8proc
  ];

  preConfigure = (super.preConfigure or "") + ''
    cp -T ${cmakeGenerateVersion} cmake/GenerateVersion.cmake
    substituteInPlace cmake.config/versiondef.h.in \
      --subst-var-by NVIM_VERSION_PRERELEASE "-${final.version}"
  '';

  cmakeFlagsArray = super.cmakeFlagsArray ++ [
    "-DENABLE_LTO=OFF"
  ];

  meta = super.meta // {
    description = "${super.meta.description} (Kiwi Edition)";
  };
})
