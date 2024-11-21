{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, makeWrapper

, openssl
, rustup
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-msrv";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lcIzRtpp3OkRI//VbUyABrl5YItRCJ2HJ4FQ+Ske6uw=";
  };

  cargoHash = "sha256-UKGJhS3vTupLCzwijCmO32YZ2m7dCZr/XSIfVkVxgqE=";

  # Integration tests fail
  doCheck = false;

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs = [ openssl ];

  # Depends at run-time on having rustup in PATH
  postInstall = ''
    wrapProgram $out/bin/cargo-msrv \
      --prefix PATH : ${lib.makeBinPath [ rustup ]};
  '';

  meta = with lib; {
    description = "Cargo subcommand \"msrv\": assists with finding your minimum supported Rust version (MSRV)";
    mainProgram = "cargo-msrv";
    homepage = "https://github.com/foresterre/cargo-msrv";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ otavio matthiasbeyer ];
  };
}
