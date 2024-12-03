{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.221.2";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-tools";
    rev = "v${version}";
    hash = "sha256-agntGQkwXNMJSm7AgjhYDeWyCxCh/0edNxJgvbeUyfU=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;
  cargoHash = "sha256-il9Zdj50XBMCxiOyQwyToOtaP34hcklOwlDuVGEmyVY=";

  cargoBuildFlags = [ "--package" "wasm-tools" ];
  cargoTestFlags = [ "--all" ];

  meta = with lib; {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre ];
    mainProgram = "wasm-tools";
  };
}
