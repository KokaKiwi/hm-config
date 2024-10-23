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
    rev = "b7d8d8ac64c88c643475681167ebdfce0725338c";
    hash = "sha256-6QSCQ2tITB1SroYmfV7oF/j0TfxuboMDEY8G9jvwTqM=";
  };

  cargoHash = "sha256-xrf3TLsMQ8NrwQS9h6uTQwcrYAQ28B7F7MgYPpPswtg=";

  meta = {
    mainProgram = "cargo-shell";
  };
}
