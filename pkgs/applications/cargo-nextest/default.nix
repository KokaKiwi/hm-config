{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.74";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    hash = "sha256-pAy8sEMRmTNRYyL377a2laqnXmXniqa8S4qUuf5mZag=";
  };

  cargoHash = "sha256-H4qs1V7hGua0BCZqIGYyKQe6MCN/DpL9x7wJAADHFG8=";

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
