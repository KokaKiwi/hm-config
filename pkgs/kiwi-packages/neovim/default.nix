{ lib, llvmStdenv, callPackage

, fetchFromGitHub

, fenixStableToolchain
, makeRustPlatform
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

    version = "2.1.1720049189";

    src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "04dca7911ea255f37be799c18d74c305b921c1a6";
      hash = "sha256-IvkOwyKXUqo++A0XalCKuS0uLj5PlTOUQX1qXDP6JBk=";
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
  version = "nightly-unstable-2024-08-09";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "0d3f2c4904d552635da07a6e2b4e75520b514940";
    hash = "sha256-2tWPZEh8yxS+PwliMwGiEnWvkaOdyhTEQQtGSZ9ghLg=";
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
