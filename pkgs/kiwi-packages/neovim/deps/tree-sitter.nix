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
    version = "0.24.1-unstable-2024-10-04";

    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter";
      rev = "666db18c28ea2da32ee0c124e4ce8a00976ecd45";
      hash = "sha256-++HwjDqajSsnPu5KyQkddi9WxzkW51f5nPou306bCCU=";
    };

    cargoHash = "sha256-aJ986q46mvv85pDmoNM0Uq5VsYu9DGQ6AxLC7vBWpTo=";

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
