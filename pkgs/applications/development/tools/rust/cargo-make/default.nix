{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, bzip2
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.37.17";

  src = fetchFromGitHub {
    owner = "sagiegurari";
    repo = "cargo-make";
    rev = version;
    hash = "sha256-v6UzkFenqZs3l+3N3U+tYF6N2Ft+GtdqAyHCksc368E=";
  };

  cargoHash = "sha256-13mM1O8fX2R3v0nv2aDiHS6qU+BBTHikJN993EAUJzA=";

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
