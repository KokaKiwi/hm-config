{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "wit-bindgen";
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wit-bindgen";
    rev = "v${version}";
    hash = "sha256-bxA+SsuxDbeORbuul2A0+a2tD0m8IPG5mCekKiHv+uw=";
  };

  cargoHash = "sha256-Wujmj/HArLy7s5ZqZlOZssE9CxsXzkM97N61GVb6M88=";

  # Some tests fail because they need network access to install the `wasm32-unknown-unknown` target.
  # However, GitHub Actions ensures a proper build.
  # See also:
  #   https://github.com/bytecodealliance/wit-bindgen/actions
  #   https://github.com/bytecodealliance/wit-bindgen/blob/main/.github/workflows/main.yml
  doCheck = false;

  meta = with lib; {
    description = "Language binding generator for WebAssembly interface types";
    homepage = "https://github.com/bytecodealliance/wit-bindgen";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "wit-bindgen";
  };
}
