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
  version = "0-unstable-2024-10-30";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "attic";
    rev = "48c8b395bfbc6b76c7eae74df6c74351255a095c";
    hash = "sha256-OQl+aAsKiyygvpzck1u0sZf/R4T9zM903CgNDFmmzA8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
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
