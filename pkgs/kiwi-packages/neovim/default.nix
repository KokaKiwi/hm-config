{ callPackage

, fetchFromGitHub

, fenixStableToolchain
, makeRustPlatform

, luajit
, llvmPackages_latest
, neovim-unwrapped

, libiconv
}:
let
  llvmPackages = llvmPackages_latest;

  stdenv = llvmPackages_latest.stdenv.override (super: {
    cc = super.cc.override {
      inherit (llvmPackages) bintools;
    };
  });

  lua = luajit.override {
    inherit stdenv;
  };
  rustPlatform = makeRustPlatform {
    rustc = fenixStableToolchain;
    cargo = fenixStableToolchain;

    inherit stdenv;
  };

  tree-sitter = callPackage ./deps/tree-sitter.nix {
    inherit rustPlatform;
  };
in (neovim-unwrapped.override {
  inherit stdenv;
  inherit lua tree-sitter;
}).overrideAttrs (final: super: {
  version = "nightly-unstable-2024-05-21";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "81a1d7258c39322e62082320c0615c4659dc5ee5";
    hash = "sha256-WNHvHX1vtHXeX3/GH/zz8RtAMP/MN5/rrv3pNIyx28Y=";
  };

  inherit tree-sitter;

  NIX_CFLAGS_COMPILE = toString [
    "-O2" "-march=skylake"
    "-flto=full"
    "-mllvm" "-polly"
    "-mllvm" "-polly-parallel"
    "-mllvm" "-polly-num-threads=8"
  ];
  NIX_CFLAGS_LINK = toString [
    "-lgomp"
  ];

  nativeBuildInputs = super.nativeBuildInputs ++ [
    libiconv
  ];

  preConfigure = (super.preConfigure or "") + ''
    substituteInPlace cmake.config/versiondef.h.in \
      --subst-var-by NVIM_VERSION_PRERELEASE "-${final.version}"
  '';

  cmakeFlagsArray = super.cmakeFlagsArray ++ [
    "-DENABLE_LTO=OFF"
  ];
})
