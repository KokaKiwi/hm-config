{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-s6GcUMxR4TSt1Qe7umqXElGW87Sq9NoFNp9Cs5/bTec=";
  };

  cargoHash = "sha256-Yl07Bs/WVYhqZRpJWMZ3464t/JyAdKNyC/UU+Tbk378=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
