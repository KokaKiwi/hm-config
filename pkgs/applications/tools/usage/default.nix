{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-oOyrpgWLBwfXsdVv3cQY/9ihM61FG+DXhTt4/jetT8M=";
  };

  cargoHash = "sha256-iVvcfEyHFmXM4oNmO1+eKrwbjtOXE9ec1mCicFinSy8=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
