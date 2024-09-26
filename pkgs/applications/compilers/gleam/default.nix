{ lib

, fetchFromGitHub

, rustPlatform

, gitMinimal
, pkg-config
, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "gleam";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4/NDZGq62M0tdWerIkmoYS0WHC06AV8c9vlo/6FhsAo=";
  };

  nativeBuildInputs = [ gitMinimal pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-B8tCVkubP04gAHKQC0idR5AjpVHG/kCXvPCfwKCuaSo=";

  meta = with lib; {
    description = "A statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    license = licenses.asl20;
    maintainers = teams.beam.members;
  };
}
