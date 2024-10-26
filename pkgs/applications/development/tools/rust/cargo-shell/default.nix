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
    rev = "6597b963130604d4c1ef97110757d8906299a503";
    hash = "sha256-d8KYP+THPD8Nw/MfHueB90nJN/OnVmsswQEH5Xqg/II=";
  };

  cargoHash = "sha256-DGNYD8WJrLTiLcRxImoip+N1qz/dem+ozU+wQiDNaj0=";

  meta = {
    mainProgram = "cargo-shell";
  };
}
