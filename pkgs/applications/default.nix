{ pkgs, lib, callPackage, sources }:
let
  inherit (pkgs) libsForQt5;

  callRustPackage = lib.callPackageWith (pkgs // {
    craneLib = pkgs.craneLibStable;
    rustPlatform = pkgs.fenixStableRustPlatform;
  });

  python3 = pkgs.python312;
  python3Packages = python3.pkgs;
  callPythonPackage = lib.callPackageWith (pkgs // rec {
    inherit python3 python3Packages;
  });
in {
  agenix = callPackage "${sources.agenix}/pkgs/agenix.nix" { };
  ast-grep = callRustPackage ./ast-grep { };
  attic-client = callRustPackage ./attic-client { };
  bitwarden-cli = callPackage ./bitwarden-cli {
    inherit python3;
  };
  cargo-about = callRustPackage ./development/tools/cargo-about { };
  cargo-deny = callRustPackage ./cargo-deny { };
  cargo-depgraph = callRustPackage ./cargo-depgraph { };
  cargo-ndk = callRustPackage ./cargo-ndk { };
  cargo-nextest = callRustPackage ./cargo-nextest { };
  cargo-shell = callRustPackage ./cargo-shell { };
  colmena = callRustPackage ./colmena { };
  docker-credential-helpers = callPackage ./docker-credential-helpers { };
  eza = callRustPackage ./eza { };
  fd = callRustPackage ./fd { };
  gh = callPackage ./version-management/gh { };
  gitui = callRustPackage ./gitui { };
  glab = callPackage ./glab { };
  gleam = callRustPackage ./compilers/gleam { };
  jellyfin-media-player = libsForQt5.callPackage ./jellyfin-media-player { };
  kitty = callPythonPackage ./terminal-emulators/kitty { };
  kitty-themes = callPackage ./terminal-emulators/kitty/themes.nix { };
  mise = callRustPackage ./mise { };
  minio-client = callPackage ./tools/networking/minio-client { };
  module-server = callPythonPackage ./module-server { };
  mux = callRustPackage ./mux { };
  nixd = callPackage ./nixd {
    llvmPackages = pkgs.llvmPackages_16;
    nix = pkgs.nixVersions.nix_2_19;
  };
  npins = callRustPackage ./npins { };
  onefetch = callRustPackage ./onefetch { };
  pdm = callPythonPackage ./pdm { };
  pgcli = python3Packages.callPackage ./pgcli { };
  ponysay = callPackage ./ponysay { };
  ptpython = python3Packages.callPackage ./ptpython { };
  rustup = callRustPackage ./rustup { };
  sccache = callRustPackage ./development/tools/sccache { };
  skopeo = callPackage ./skopeo { };
  starship = callRustPackage ./starship { };
  stockfish = callPackage ./games/stockfish { };
  usage = callRustPackage ./usage { };
  xinspect = callRustPackage ./xinspect { };
  yt-dlp = python3Packages.callPackage ./misc/yt-dlp { };
}
