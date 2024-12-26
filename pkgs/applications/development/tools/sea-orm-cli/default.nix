{ lib

, fetchCrate

, rustPlatform

, pkg-config

, openssl
}:
rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
  version = "1.1.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-4j4jeZBe4HyPpa8Em4/zPcIjlJmGfymyEJP2PfDdELQ=";
  };

  cargoHash = "sha256-ZdKDQUBpFEVBvvGCulRH+riTeLoXGMMBn2RGSL1uUy4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    homepage = "https://www.sea-ql.org/SeaORM";
    description = " Command line utility for SeaORM";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ traxys ];
  };
}
