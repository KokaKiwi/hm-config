{ lib

, fetchFromGitHub

, rustPlatform

, tree-sitter
}:
let
  final = rustPlatform.buildRustPackage rec {
    pname = "tree-sitter";
    version = "0.22.6";

    src = fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter";
      rev = "v${version}";
      hash = "sha256-jBCKgDlvXwA7Z4GDBJ+aZc52zC+om30DtsZJuHado1s=";
    };

    cargoHash = "sha256-44FIO0kPso6NxjLwmggsheILba3r9GEhDld2ddt601g=";

    postPatch = ''
      # remove web interface
      sed -e '/pub mod playground/d' \
          -i cli/src/lib.rs
      sed -e 's/playground,//' \
          -e 's/playground::serve(&grammar_path.*$/println!("ERROR: web-ui is not available in this nixpkgs build; enable the webUISupport"); std::process::exit(1);/' \
          -i cli/src/main.rs
    '';

    doCheck = false;

    postInstall = ''
      make install PREFIX=$out
      rm $out/lib/*.so{,.*}
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
