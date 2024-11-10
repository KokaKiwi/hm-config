{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-pV37KRjPUgQVm9855sAgFhNrEWX4MC7qeMnmHoUj23k=";
  };

  cargoHash = "sha256-x68MZnQXQS1qKQQ2zdCI3KcpD1+At7oeVdBHa+4UeV4=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
