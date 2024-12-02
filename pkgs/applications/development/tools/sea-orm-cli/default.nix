{ lib

, fetchCrate

, rustPlatform

, pkg-config

, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
  version = "1.1.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-+g93cKhoqr97mAqHl9Gw6rnM+hCQjpnGHvVB7IjCGkA=";
  };

  cargoHash = "sha256-jd6498C6nsuKZvHFYviMtPzmrTUhuIzKrVFlrUCe4qE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    homepage = "https://www.sea-ql.org/SeaORM";
    description = " Command line utility for SeaORM";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ traxys ];
  };
}
