{ llvmStdenv, callPackage

, fetchFromGitHub

, fenixStableToolchain
, makeRustPlatform
, writeText

, luajit
, neovim-unwrapped

, libiconv
}:
let
  stdenv = llvmStdenv;

  lua = luajit.override {
    inherit stdenv;
  };
  rustPlatform = makeRustPlatform {
    rustc = fenixStableToolchain;
    cargo = fenixStableToolchain;

    inherit stdenv;
  };

  cmakeGenerateVersion = writeText "GenerateVersion.cmake" ''
    if (NOT EXISTS ''${OUTPUT})
      file(WRITE ''${OUTPUT} "")
    endif ()
  '';

  tree-sitter = callPackage ./deps/tree-sitter.nix {
    inherit rustPlatform;
  };
in (neovim-unwrapped.override {
  inherit stdenv;
  inherit lua tree-sitter;
}).overrideAttrs (final: super: {
  version = "nightly-unstable-2024-05-27";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "9a0239fdc8b380a8a32739a7c722fe90e3c2e910";
    hash = "sha256-YsiyQzGY//u2qVBH+7Nn31VmafEYDZfuyRz5kbMwHxA=";
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
  ];

  preConfigure = (super.preConfigure or "") + ''
    cp -T ${cmakeGenerateVersion} cmake/GenerateVersion.cmake
    substituteInPlace cmake.config/versiondef.h.in \
      --subst-var-by NVIM_VERSION_PRERELEASE "-${final.version}"
  '';

  cmakeFlagsArray = super.cmakeFlagsArray ++ [
    "-DENABLE_LTO=OFF"
  ];
})
