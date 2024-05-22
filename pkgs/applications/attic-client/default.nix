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
  version = "unstable-2024-03-29";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "attic";
    rev = "4dbdbee45728d8ce5788db6461aaaa89d98081f0";
    hash = "sha256-0O4v6e4a1toxXZ2gf5INhg4WPE5C5T+SVvsBt+45Mcc=";
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
