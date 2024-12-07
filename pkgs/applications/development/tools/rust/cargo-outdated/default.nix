{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config

, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.15.0-unstable-2024-12-03";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = "cargo-outdated";
    rev = "0d5f4a7bc166ce17d051259e9cc9ba9cb9a9eb01";
    hash = "sha256-tl9GP/cH50ZDzTRurySENK/Rvjde6cxyf/ZFFMtZdyU=";
  };

  cargoHash = "sha256-ZmbhfKKM365dlTpgAOZJTlfe93ZA+NsyW/ExclWOH84=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Cargo subcommand for displaying when Rust dependencies are out of date";
    mainProgram = "cargo-outdated";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    changelog = "https://github.com/kbknapp/cargo-outdated/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ ivan matthiasbeyer ];
  };
}
