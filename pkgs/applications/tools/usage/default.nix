{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-vHZ5CZiFvbG5Xx0nOIpcKgi10Hk6DieMIXRFjke2tOY=";
  };

  cargoHash = "sha256-5HEMGGR+sYOERAnSkDz0K77P8BitXyXMepjIrYFxPng=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
