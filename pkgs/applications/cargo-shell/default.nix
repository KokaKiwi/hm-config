{ fetchFromGitLab

, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "cargo-shell";
  version = "0.1-unstable-2024-04-12";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/tools";
    repo = "cargo-shell";
    rev = "a75033c8fb53e65ff74856ddbcc7ef7bd3b3f715";
    hash = "sha256-RwLXAloNOPQ0LEGpE3/xlsfKdxWYA3QH9JGYhdpgD44=";
  };

  cargoHash = "sha256-ACARVMrYJ+cihPnM/6nGKxdEK9fVYvwKeCaeZqCW/Bs=";

  meta = {
    mainProgram = "cargo-shell";
  };
}
