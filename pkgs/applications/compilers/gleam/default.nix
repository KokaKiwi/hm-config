{ lib

, fetchFromGitHub

, rustPlatform

, gitMinimal
, pkg-config
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-J3FqaKEeK+Xy8Ri5j7+K+4wpvNeMUHSfj2O68XBPlYs=";
  };

  nativeBuildInputs = [ gitMinimal pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-l0LFgmsk87mCVu1UiaFtP3mO01CDV3xTz4Kv+l6AAWw=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
