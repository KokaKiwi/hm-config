{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.49";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gjDe36fp315QRJEaQayoxM2eWrmMlN2AmCep63K5MC8=";
  };

  cargoHash = "sha256-x++h5FOb5LXV9miRYZjnZcmp2Djn0P2gdBLAOO977IU=";

  nativeBuildInputs = [ pkg-config ];

  # TODO figure out how to use provided curl instead of compiling curl from curl-sys
  buildInputs = [ openssl ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    description = "Find unused dependencies in Cargo.toml";
    homepage = "https://github.com/est31/cargo-udeps";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n matthiasbeyer ];
    mainProgram = "cargo-udeps";
  };
}
