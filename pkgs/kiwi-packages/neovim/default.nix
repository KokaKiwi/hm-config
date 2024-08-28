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

    version = "2.1.unstable";

    src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "f725e44cda8f359869bf8f92ce71787ddca45618";
      hash = "sha256-DvgAfh0jUB4oXO22tCdIofIihAD/FXhwD+5/GqG7GGY=";
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
  version = "nightly-unstable-2024-08-28";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "0346666f717576d31be411cd59b07c81eff18f95";
    hash = "sha256-quk7W+ZCXMVbvxpgN5I21JgkHTqSvJab4tgff9Jp9MI=";
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
