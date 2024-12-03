{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-4oFoblnv+IBmzVHtwVuiBu3+zlFNL2QYH1QWTnzUMmE=";
  };

  cargoHash = "sha256-x0PJhhOgT+LPgVmFMyHlkXYWkWHRBK49jj6sVXkE3ek=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
