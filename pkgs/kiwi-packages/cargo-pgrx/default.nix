{ lib, stdenv, darwin

, fetchFromGitHub

, rustPlatform

, pkg-config

, bzip2
, openssl
, zlib
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-pgrx";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "pgcentralfoundation";
    repo = "pgrx";
    rev = "v${version}";
    hash = "sha256-3GdnfysTf8XugTuQQ/pVtepNHlGriq+XltLtbYcr+VA=";
  };

  cargoHash = "sha256-6rCvZ2hIjBaE6v1HNc/Wzt1gwp+c6qNniVMYzF+U4xU=";

  cargoBuildFlags = [ "-p" "cargo-pgrx" ];
  cargoTestFlags = cargoBuildFlags;

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    bzip2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Security
  ]);

  checkFlags = [
    "--skip=command::schema::tests::test_parse_managed_postmasters"
  ];

  meta = with lib; {
    description = "Build Postgres Extensions with Rust";
    homepage = "https://github.com/pgcentralfoundation/pgrx";
    changelog = "https://github.com/pgcentralfoundation/pgrx/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "cargo-pgrx";
  };
}
