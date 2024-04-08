{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, openssl

, withLsp ? true
}:
rustPlatform.buildRustPackage rec {
  pname = "taplo";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "tamasfe";
    repo = "taplo";
    rev = "release-taplo-${version}";
    hash = "sha256-CgWeaxroKgapk6bz7rY/+UN7IR0WV1mKKsW0+bVmXnk=";
  };

  cargoHash = "sha256-A1jY1GGUZ2dzIwb1J3nyCbbidRrMEfzUFwbVYFQXDMw=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  buildFeatures = lib.optional withLsp "lsp";

  meta = {
    description = "A TOML toolkit written in Rust";
    homepage = "https://taplo.tamasfe.dev";
    license = lib.licenses.mit;
    mainProgram = "taplo";
  };
}
