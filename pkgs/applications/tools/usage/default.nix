{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-tKwJYVQYNh6m50Dx/s8KSS4qSU6JYnurL33RWX5g2ow=";
  };

  cargoHash = "sha256-5hfBMglFetEzv0nsLbqYHr15fIwctchbzqtT+0fJI6U=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
