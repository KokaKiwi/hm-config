{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-IM9MF+0zaRU0rRJPAJnn3WaAri+tY6mO/vQY+f1BoyY=";
  };

  cargoHash = "sha256-5CCcdNr5WWD5a3MgoLkzXQbZbXce1RVt+jhE3B49yZA=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
