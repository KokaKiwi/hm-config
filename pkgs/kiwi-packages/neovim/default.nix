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
  version = "nightly-unstable-2024-05-24";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "a616272f568a9492580abfd22ab460457ecdbfa3";
    hash = "sha256-TcDA9zJgJ/gL/B3rKF9zrNXI2FLf5qoPfr63D8QVQXA=";
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
