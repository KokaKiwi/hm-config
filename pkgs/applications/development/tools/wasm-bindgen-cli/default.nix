{ lib, stdenv
, darwin

, fetchCrate

, rustPlatform

, pkg-config

, openssl

, curl

, nodejs_latest

, version ? "0.2.99"
, hash ? "sha256-1AN2E9t/lZhbXdVznhTcniy+7ZzlaEp/gwLEAucs6EA="
, cargoHash ? "sha256-DbwAh8RJtW38LJp+J9Ht8fAROK9OabaJ85D9C/Vkve4="
}:
rustPlatform.buildRustPackage rec {
  pname = "wasm-bindgen-cli";
  inherit version hash cargoHash;

  src = fetchCrate { inherit pname version hash; };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      curl
      darwin.apple_sdk.frameworks.Security
    ];

  nativeCheckInputs = [ nodejs_latest ];

  # tests require it to be ran in the wasm-bindgen monorepo
  doCheck = false;

  meta = {
    homepage = "https://rustwasm.github.io/docs/wasm-bindgen/";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    description = "Facilitating high-level interactions between wasm modules and JavaScript";
    maintainers = with lib.maintainers; [ rizary ];
    mainProgram = "wasm-bindgen";
  };
}
