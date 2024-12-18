{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-VeSe6WV1Tpy1PQ33EbgmFi6YWWxz3bQksW06sTHTuJU=";
  };

  cargoHash = "sha256-Pn5tUublRo37nBLM1baQ4ey0KL7iAilpHrB/caOSK0I=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
