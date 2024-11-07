{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config

, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.21.4";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-tU0Xob0dS1+rrfRVitwOe0K1AG05LHlGPHhFL0yOjxM=";
  };

  cargoHash = "sha256-iuxACtr91qWzojKWaieAd6kk/q9j5JSD1Fa50oCKogA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  checkFlags = [
    # requires network
    "--skip=tools::tests::download_and_install_binaries"
  ];

  meta = with lib; {
    homepage = "https://github.com/trunk-rs/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    mainProgram = "trunk";
    maintainers = with maintainers; [ freezeboy ctron ];
    license = with licenses; [ asl20 ];
  };
}
