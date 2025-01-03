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
    version = "0.24.6-unstable-2025-01-03";

    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter";
      rev = "2c064039c7f790c47c1fefe32a85bee756e957ac";
      hash = "sha256-rNU2g1bsjwRqa7rZIjkBk4kBbujiJNQkdDs8B/cijr0=";
    };

    cargoHash = "sha256-8U0EhQ6RZBfieZoZYFYUm4Xsk+xXo9wL4mD0OuG/P68=";

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
      make install \
        PREFIX=$out \
        CC="${stdenv.cc}/bin/cc" \
        CFLAGS="$NIX_CFLAGS_COMPILE ${toString cFlags}" \
        LDFLAGS="$NIX_LDFLAGS"
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
