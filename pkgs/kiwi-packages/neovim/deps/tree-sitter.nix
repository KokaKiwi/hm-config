{ lib, stdenv

, fetchFromGitHub

, rustPlatform
, cmake

, tree-sitter

, withWasm ? true, wasmtime-c-api
}:
let
  final = rustPlatform.buildRustPackage rec {
    pname = "tree-sitter";
    version = "0.24.1-unstable-2024-10-05";

    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter";
      rev = "c611e15a310d9af2ed18172ef1faafaf18506176";
      hash = "sha256-buVKxC2x8LNTRfONW3ulNzW6Q120bW+bmpzwmUx7E6k=";
    };

    cargoHash = "sha256-fDauLNrIYmQXpKGz9ElRnI+zXh7LXo7r+mWpvlp6giY=";

    nativeBuildInputs = lib.optionals withWasm [ cmake ];

    buildInputs = lib.optionals withWasm [
      wasmtime-c-api
    ];

    buildFeatures = lib.optional withWasm "wasm";
    cargoBuildFlags = [ "-p" "tree-sitter-cli" ];

    doCheck = false;

    postInstall = let
      cFlags = lib.optionals withWasm [
        "-DTREE_SITTER_FEATURE_WASM"
      ];
    in ''
      make all \
        PREFIX=$out \
        LIBDIR=lib INCLUDEDIR=include \
        CC="${stdenv.cc}/bin/cc" \
        CFLAGS="$NIX_CFLAGS_COMPILE ${toString cFlags}" \
        LDFLAGS="$NIX_LDFLAGS"

      make install PREFIX=$out
    '';

    passthru = {
      buildGrammar = tree-sitter.buildGrammar.override {
        tree-sitter = final;
      };
    };

    meta = {
      homepage = "https://github.com/tree-sitter/tree-sitter";
      description = "A parser generator tool and an incremental parsing library";
      mainProgram = "tree-sitter";
      changelog = "https://github.com/tree-sitter/tree-sitter/blob/v${version}/CHANGELOG.md";
      longDescription = ''
        Tree-sitter is a parser generator tool and an incremental parsing library.
        It can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited.

        Tree-sitter aims to be:

        * General enough to parse any programming language
        * Fast enough to parse on every keystroke in a text editor
        * Robust enough to provide useful results even in the presence of syntax errors
        * Dependency-free so that the runtime library (which is written in pure C) can be embedded in any application
      '';
      license = lib.licenses.mit;
    };
  };
in final
