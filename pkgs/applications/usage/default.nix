{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-ftv27SvUg7sF0tXRCv9pk8LLahjNnLvvuq5GNtXxG9g=";
  };

  cargoHash = "sha256-1F7JUhrFBY9ETD57loIIh1znvSY2VmD1zEUGiWLlHoQ=";

  meta = {
    mainProgram = "usage";
  };
}
