{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config

, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-+QcHmV6VJI7OH8AGGNrzd8I6s+eT1afZEIPfXh3OZE4=";
  };

  cargoHash = "sha256-Xkz2V9NlfKPWiqIFtGw5cDS8W33z2AS+Uxhvz4drXaA=";

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
