{ lib, stdenv
, darwin

, fetchFromGitHub

, rustPlatform

, pkg-config

, libgit2
, openssl
, curl

, git
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-release";
  version = "0.25.14";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    rev = "refs/tags/v${version}";
    hash = "sha256-C2FC/WP7xPC/DNSWyZFSHvbfxskjlr7HXuDRrq4t3uk=";
  };

  cargoHash = "sha256-uCVMyW5QvZTPQ93JVXEEp0kfKFWbqNbp5HMYin+gmDc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  nativeCheckInputs = [
    git
  ];

  # disable vendored-libgit2 and vendored-openssl
  buildNoDefaultFeatures = true;

  meta = with lib; {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    mainProgram = "cargo-release";
    homepage = "https://github.com/crate-ci/cargo-release";
    changelog = "https://github.com/crate-ci/cargo-release/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda gerschtli ];
  };
}
