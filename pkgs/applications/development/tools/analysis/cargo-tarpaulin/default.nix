{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-tarpaulin";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "xd009642";
    repo = "tarpaulin";
    rev = version;
    hash = "sha256-JD+seB8gvDFjT/O32bOba1VTzj1Kpj3zNhbN7Hstz7Q=";
  };

  cargoHash = "sha256-d/MVdZWwpre5H6GHZbX9Z9jqWtAUmm8BcCFTG2m09F0=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ openssl ];

  doCheck = false;

  meta = with lib; {
    description = "Code coverage tool for Rust projects";
    mainProgram = "cargo-tarpaulin";
    homepage = "https://github.com/xd009642/tarpaulin";
    changelog = "https://github.com/xd009642/tarpaulin/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda hugoreeves ];
  };
}
