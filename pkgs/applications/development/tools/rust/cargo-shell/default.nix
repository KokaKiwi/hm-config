{ fetchFromGitLab

, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "cargo-shell";
  version = "0-unstable-2024-10-08";

  src = fetchFromGitLab {
    domain = "gitlab.kokakiwi.net";
    owner = "rusted/tools";
    repo = "cargo-shell";
    rev = "09a2e1b70c4a12d3cd86c46c2bb6a26755d04902";
    hash = "sha256-zyza/W0wz5AfUgx9hPQxGVw87gcseV0MxfL4qmi79kY=";
  };

  cargoHash = "sha256-Z2qKkvdn/AlN0rcTkB6MstpkpP3baKSg1xWOEP6obv0=";

  meta = {
    mainProgram = "cargo-shell";
  };
}
