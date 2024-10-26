{ fetchFromGitLab

, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "cargo-shell";
  version = "0-unstable-2024-10-26";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/tools";
    repo = "cargo-shell";
    rev = "6f5e4c9e93c155dc84af1a4a9f8a762dc3f350ca";
    hash = "sha256-zAjHht9S20LI8sanFoPihnrXoW0Tu7Izl0bgruIqS/I=";
  };

  cargoHash = "sha256-DGNYD8WJrLTiLcRxImoip+N1qz/dem+ozU+wQiDNaj0=";

  meta = {
    mainProgram = "cargo-shell";
  };
}
