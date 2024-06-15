{ lib, llvmStdenv, callPackage

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

    version = "2.1.1716656478";

    src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "93e87998b24021b94de8d1c8db244444c46fb6e9";
      hash = "sha256-0ORSNetyCWwTx7W4G7viZJ3k7hdardAYwgbYQSh4kWg=";
    };
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
  version = "nightly-unstable-2024-06-15";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "aa319da4024a77b0f7c40e08c6f5d5b512a7f899";
    hash = "sha256-YaZyuhBSZFnwoMwe790NjzUyff/Ml93jJ6wxj4dCFdc=";
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
