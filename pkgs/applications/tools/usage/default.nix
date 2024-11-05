{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-WYdloWoepXWEwqOblw2+8JRRuGLYaGVqv+j8akG7q+Q=";
  };

  cargoHash = "sha256-+FCSn2UTjKefiH2tPO9HpvtqRwZrrwkeuk1y1Z+LphI=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
