{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
  version = "1.219.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-tools";
    rev = "v${version}";
    hash = "sha256-9FAq6wcTXXFdQ5kcpkj2KqTcd8C8zXmhRWW/ajCJUMI=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;
  cargoHash = "sha256-moBRkUbcIGZaVdcE3yDtREtG4unN4n5yA7edpnrUFg4=";

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
