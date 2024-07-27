{ lib, stdenv

, fetchFromGitHub

, darwin
, rustPlatform

, pkg-config
, zstd
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-deny";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-deny";
    rev = version;
    hash = "sha256-jzjPull33GOJ0ZPDdtTxy21jKjM8sdtzLs6d/J0VsEM=";
  };

  cargoHash = "sha256-DgRSMRmSZmvEWgXFjvs94CMB5S4Lb4mk4mJ7sqLXrEc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    mainProgram = "cargo-deny";
    homepage = "https://github.com/EmbarkStudios/cargo-deny";
    changelog = "https://github.com/EmbarkStudios/cargo-deny/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda matthiasbeyer jk ];
  };
}
