{ pkgs, super, lib, callPackage, sources }:
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

  go = super.go.overrideAttrs rec {
    version = "1.22.4";
    src = pkgs.fetchurl {
      url = "https://go.dev/dl/go${version}.src.tar.gz";
      hash = "sha256-/tcgZ45yinyjC6jR3tHKr+J9FgKPqwIyuLqOIgCPt4Q=";
    };
  };
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
  cargo-show-asm = callRustPackage ./development/tools/cargo-show-asm { };
  colmena = callRustPackage ./colmena { };
  docker-credential-helpers = callPackage ./docker-credential-helpers { };
  eza = callRustPackage ./eza { };
  fd = callRustPackage ./fd { };
  gh = callPackage ./version-management/gh { };
  git-interactive-rebase-tool = callRustPackage ./version-management/git-interactive-rebase-tool { };
  gitui = callRustPackage ./gitui { };
  glab = callPackage ./glab {
    buildGoModule = super.buildGoModule.override {
      inherit go;
    };
  };
  gleam = callRustPackage ./compilers/gleam { };
  imhex = callPackage ./misc/imhex { };
  jellyfin-media-player = libsForQt5.callPackage ./jellyfin-media-player { };
  kitty = callPythonPackage ./terminal-emulators/kitty { };
  kitty-themes = callPackage ./terminal-emulators/kitty/themes.nix { };
  kubo = callPackage ./kubo { };
  mise = callRustPackage ./mise { };
  minio-client = callPackage ./tools/networking/minio-client { };
  module-server = callPythonPackage ./module-server { };
  mux = callRustPackage ./mux { };
  nixd = callPackage ./nixd {
    llvmPackages = pkgs.llvmPackages_16;
    nix = pkgs.nixVersions.nix_2_19;
  };
  npins = callRustPackage ./npins { };
  obsidian = callPackage ./misc/obsidian { };
  onefetch = callRustPackage ./onefetch { };
  pdm = callPythonPackage ./pdm { };
  pgcli = python3Packages.callPackage ./pgcli { };
  ponysay = callPackage ./ponysay { };
  ptpython = python3Packages.callPackage ./ptpython { };
  pueue = callRustPackage ./misc/pueue { };
  rustup = callRustPackage ./rustup { };
  sccache = callRustPackage ./development/tools/sccache { };
  skopeo = callPackage ./skopeo { };
  starship = callRustPackage ./starship { };
  stockfish = callPackage ./games/stockfish { };
  trunk = callRustPackage ./development/tools/trunk { };
  usage = callRustPackage ./usage { };
  xinspect = callRustPackage ./xinspect { };
  yt-dlp = python3Packages.callPackage ./misc/yt-dlp { };
}
