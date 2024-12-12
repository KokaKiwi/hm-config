{ fetchFromGitHub, rustPlatform}:
rustPlatform.buildRustPackage rec {
  pname = "usage";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "usage";
    rev = "v${version}";
    hash = "sha256-hgW0u2Trv/IvKjz2H2GLD7bUrqnhdbeKSf67RxHjhVU=";
  };

  cargoHash = "sha256-Ij7ykqT4XdAq6XoZWvGJHYqc+Tf3yqfsUSG9/3pDJvk=";

  checkFlags = [
    "--skip=complete_word_mounted"
  ];

  meta = {
    mainProgram = "usage";
  };
}
