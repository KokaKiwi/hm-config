{ lib

, fetchCrate

, rustPlatform

, pkg-config

, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
  version = "1.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-rPPOVU5oyBIywiJuK23PutfvhxaFNi/VZ9kVWLMUVjI=";
  };

  cargoHash = "sha256-r5nqzu79z/XdrqvaJ+5ylZI6tC/SKTzmoOSgkbAaPn4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    homepage = "https://www.sea-ql.org/SeaORM";
    description = " Command line utility for SeaORM";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ traxys ];
  };
}
