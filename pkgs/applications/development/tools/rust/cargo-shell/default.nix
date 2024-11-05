{ fetchFromGitLab

, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "cargo-shell";
  version = "0-unstable-2024-11-05";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/tools";
    repo = "cargo-shell";
    rev = "a527d02029f9a823bdb309dfcac83a22be7a43a2";
    hash = "sha256-yovvR/AJznt1BM3yriMewKs0s2NqvvXq9DJwqJIMtgA=";
  };

  cargoHash = "sha256-PUUOx1FU4Ooy46i0AascTv5E5It019f3UVc2Fu1mZuw=";

  meta = {
    mainProgram = "cargo-shell";
  };
}
