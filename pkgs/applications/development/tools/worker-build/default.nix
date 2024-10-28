{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "worker-build";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-B9iOaX2enj4PhqRMmC55aW15otfaMLcBUuR2PWQ9EsY=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "psutil-3.2.1" = "sha256-0TaiJ/ZWKYGx7IxttHVrJTe1OB8R80LEZp/dfLBhZAs=";
    };
  };

  buildAndTestSubdir = "worker-build";

  meta = with lib; {
    description = "This is a tool to be used as a custom build command for a Cloudflare Workers `workers-rs` project";
    mainProgram = "worker-build";
    homepage = "https://github.com/cloudflare/workers-rs";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ happysalada ];
  };
}
