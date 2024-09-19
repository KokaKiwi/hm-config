{ lib

, fetchFromGitHub

, rustPlatform

, gitMinimal
, pkg-config
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-buMnbBg+/vHXzbBuMPuV8AfdUmYA9J6WTXP7Oqrdo34=";
  };

  nativeBuildInputs = [ gitMinimal pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-0Vtf9UXLPW5HuqNIAGNyqIXCMTITdG7PuFdw4H4v6a4=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
