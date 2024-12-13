{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-0tqtrTwLNAAybzKBwF2jT2r+lVTe+C74RXSQ0xmpVwE=";
  };

  cargoHash = "sha256-LtU31FO89vj2VvRxkg3bWlVeh2Txb7FyyzlAa3WquJY=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
