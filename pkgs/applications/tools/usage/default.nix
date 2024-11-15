{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-TQYWXXbZYvoavC7hWSani+LpQbqYHMXdigJtNGwANbU=";
  };

  cargoHash = "sha256-Xf4P0OUP8z5Keerv6MDzbYXxuUE+8tqYLkn7Pt4rK8E=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
