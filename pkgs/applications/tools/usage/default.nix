{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-E6iaJo3x9PDmHGGT93JM2icN5/8zh2Jv6uheE30bD4s=";
  };

  cargoHash = "sha256-MxH8MOLPS1wizh16sphMoOaV6APt/hPN30dtJ+4SHx4=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
