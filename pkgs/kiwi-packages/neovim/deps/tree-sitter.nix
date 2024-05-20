{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
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
}
