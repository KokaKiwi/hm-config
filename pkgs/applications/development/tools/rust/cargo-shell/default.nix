{ fetchFromGitLab

, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "cargo-shell";
  version = "0-unstable-2024-10-23";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/tools";
    repo = "cargo-shell";
    rev = "b2dcb27c3043b66cf07085c119726e6cf003f289";
    hash = "sha256-7DhiRiW2pq+YxklMe9k9xZns7KvcT+y+VEUKwdnHEW4=";
  };

  cargoHash = "sha256-xrf3TLsMQ8NrwQS9h6uTQwcrYAQ28B7F7MgYPpPswtg=";

  meta = {
    mainProgram = "cargo-shell";
  };
}
