{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, bzip2
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.37.22";

  src = fetchFromGitHub {
    owner = "sagiegurari";
    repo = "cargo-make";
    rev = version;
    hash = "sha256-j2NhQZynKtYUjwohAT0x0VF5xhKqXJsbd71y1Sf9+A4=";
  };

  cargoHash = "sha256-JEYrChYHLPQAi1BySrOzRtPKwd0Tmh84LWwwwbKUSdk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
    openssl
  ];

  # Some tests fail because they need network access.
  # However, Travis ensures a proper build.
  # See also:
  #   https://travis-ci.org/sagiegurari/cargo-make
  doCheck = false;

  meta = with lib; {
    description = "Rust task runner and build tool";
    homepage = "https://github.com/sagiegurari/cargo-make";
    changelog = "https://github.com/sagiegurari/cargo-make/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda xrelkd ];
    mainProgram = "cargo-make";
  };
}
