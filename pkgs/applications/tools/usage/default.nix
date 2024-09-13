{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-5vKEd1DT6fKwZZqVXYYSYkgcEaDP48yBbEvI2yrCl8c=";
  };

  cargoHash = "sha256-Nwj+WEKKDh5Xht9D7ZOHamuIMdSfqH9kavDo9drksTg=";

  meta = {
    mainProgram = "usage";
  };
}
