{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, bzip2
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-make";
  version = "0.37.21";

  src = fetchFromGitHub {
    owner = "sagiegurari";
    repo = "cargo-make";
    rev = version;
    hash = "sha256-y4FcJxKuU9pPgnYrpWQR/7izZNIuT+Jn7h3/hkeenYU=";
  };

  cargoHash = "sha256-Y+a0Ima1ouxD1ZZnRL/cEVjs+1+jjwLbnXxQySrPrgw=";

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
