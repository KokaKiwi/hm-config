{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-+Wt/ZOwj9LHgt0EOFF554TGf2tZyuRoXAPpCebPZfNY=";
  };

  cargoHash = "sha256-w8GWvMjC6Plho+zw542Q00hU/KZMdyyoP/rGAg72h1s=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
