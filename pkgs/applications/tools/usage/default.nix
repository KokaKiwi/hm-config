{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-808ygk7pH5/JSwwKJ8HzyaHJTVkXvG5UHHFHMRTay7Q=";
  };

  cargoHash = "sha256-yeG3o3MOUO3H/PuXomxYkLf5GkdHt+DozdjgTkCDRgA=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
