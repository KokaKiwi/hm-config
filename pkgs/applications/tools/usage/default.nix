{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-W4SUfQxxxFxWAi4Iuc3ZTVpXKSxskC1OvI0nPNZcbBo=";
  };

  cargoHash = "sha256-kBai4ES8A/eml18QGCTvVRnnr/xKm4s4MxOOuy62jlg=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
