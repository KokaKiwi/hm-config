{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-udeps";
  version = "0.1.53";

  src = fetchFromGitHub {
    owner = "est31";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-l5r0ZbF3LlGzJgMt0rPizzP0ZBLJQNLGBynPw4nAwMc=";
  };

  cargoHash = "sha256-XRK26pYVUVOUAQsWxIhY2m5bwSIqCMBZ2r34eN3RQiE=";

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
