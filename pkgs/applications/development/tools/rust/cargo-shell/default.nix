{ fetchFromGitLab

, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "cargo-shell";
  version = "0-unstable-2024-08-09";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/tools";
    repo = "cargo-shell";
    rev = "0a3a2ae6393688f9c24deef9510e4df523a48f48";
    hash = "sha256-o5MQp1mlUBKFYSssF+Q4CV84AEwEGylEa1WkpUgPyB0=";
  };

  cargoHash = "sha256-YrpZhNtA/yAejL6Dn6OSsb3CohRCMhXgroQNP1tFvCc=";

  meta = {
    mainProgram = "cargo-shell";
  };
}
