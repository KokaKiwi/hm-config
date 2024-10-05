{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.80";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    hash = "sha256-g+cL2J4IHNPx6hhGpc9fGP26ySJtzwT6W93IhdvTBmc=";
  };

  cargoHash = "sha256-1Ptwcj9vf8G3ZamBsd7fSpZIkOomObDXk8Vvi0jYgts=";

  cargoBuildFlags = [ "-p" "cargo-nextest" ];
  cargoTestFlags = [ "-p" "cargo-nextest" ];

  meta = with lib; {
    description = "Next-generation test runner for Rust projects";
    mainProgram = "cargo-nextest";
    homepage = "https://github.com/nextest-rs/nextest";
    changelog = "https://nexte.st/CHANGELOG.html";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ekleog figsoda matthiasbeyer ];
  };
}
