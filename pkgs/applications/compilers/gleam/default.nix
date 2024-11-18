{ lib

, fetchFromGitHub

, rustPlatform

, gitMinimal
, pkg-config
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-hZWN50voOhV0/BaEBklg8v9uaHfuAkLe6Vmfrh/aQUg=";
  };

  nativeBuildInputs = [ gitMinimal pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-mSR2WrdaYx7QvtQBiGurwbpUjygEIK02Hq+u1rZDy3M=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
