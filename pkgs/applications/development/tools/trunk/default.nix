{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config

, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-IRLXn6Z1HYHJiJs6qIa+A2Dwm8rx/7DuJnCoZYInWf0=";
  };

  cargoHash = "sha256-5bnhRMA1yt/6csjhCZ4/5a+ga9eF5Eof1P7QEpNI+PE=";

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
