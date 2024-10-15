{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config

, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-6EuSz7bFlL49l5gjoKCyRTfAWiwIHFdG0t+StvGj7f8=";
  };

  cargoHash = "sha256-NfGDra5xHVY04CofTriCUspLY3f4Tiq6Wm9ON0K8jwY=";

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
