{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-AXQyaGGjGmiCPRP2WaN6/7SvPze8IQ1PSNRPWf8X/9g=";
  };

  cargoHash = "sha256-LnGarvT5s7qWf5qIQH/pS3VrTuQyhCBwWuqXeCM69Ps=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
