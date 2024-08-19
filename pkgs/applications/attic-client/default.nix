{ lib

, fetchFromGitHub

, installShellFiles
, rustPlatform

, boost
, pkg-config

, nix
, sqlite
, xz
, zstd
}:
rustPlatform.buildRustPackage {
  pname = "attic-client";
  version = "0-unstable-2024-08-19";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "attic";
    rev = "acf3c351f8de47c6857f31948ab253f9c7ce2a6f";
    hash = "sha256-jcY81r8PdMQ9dCGhT0YLZzxPj3kQJXyWCmvQLXbR1EI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "nix-base32-0.1.2-alpha.0" = "sha256-wtPWGOamy3+ViEzCxMSwBcoR4HMMD0t8eyLwXfCDFdo=";
    };
  };

  nativeBuildInputs = [
    installShellFiles

    pkg-config
  ];

  buildInputs = [
    nix
    boost

    sqlite
    xz
    zstd
  ];

  cargoBuildFlags = [ "-p" "attic-client" ];

  ATTIC_DISTRIBUTOR = "dev";

  ZSTD_SYS_USE_PKG_CONFIG = true;
  NIX_INCLUDE_PATH = "${lib.getDev nix}/include";

  doCheck = false;

  postInstall = ''
    installShellCompletion --cmd attic \
      --bash <($out/bin/attic gen-completions bash) \
      --fish <($out/bin/attic gen-completions fish) \
      --zsh <($out/bin/attic gen-completions zsh)
  '';

  meta = with lib; {
    description = "Multi-tenant Nix Binary Cache";
    homepage = "https://github.com/zhaofengli/attic";
    license = licenses.asl20;
    mainProgram = "attic-client";
  };
}
