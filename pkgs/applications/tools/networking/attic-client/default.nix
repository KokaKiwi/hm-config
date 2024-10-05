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
  version = "0-unstable-2024-10-05";

  src = fetchFromGitHub {
    owner = "zhaofengli";
    repo = "attic";
    rev = "858120c450ff470d4821dcb1e1fef55371a67ad9";
    hash = "sha256-82qSmekIoV+CAdgPwN+08T9NaWEz/R10V/aBMXxgp+U=";
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
