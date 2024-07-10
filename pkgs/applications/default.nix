{ pkgs, sources }:
let
  inherit (pkgs) libsForQt5;
  inherit (pkgs.kiwiPackages) callPackage python3Packages;
in {
  agenix = callPackage "${sources.agenix}/pkgs/agenix.nix" { };
  ast-grep = callPackage ./ast-grep { };
  attic-client = callPackage ./attic-client {
    nix = pkgs.nixVersions.nix_2_18_upstream;
  };
  bitwarden-cli = callPackage ./bitwarden-cli { };
  cargo-about = callPackage ./development/tools/cargo-about { };
  cargo-deny = callPackage ./cargo-deny { };
  cargo-depgraph = callPackage ./cargo-depgraph { };
  cargo-generate = callPackage ./development/tools/rust/cargo-generate { };
  cargo-ndk = callPackage ./cargo-ndk { };
  cargo-nextest = callPackage ./cargo-nextest { };
  cargo-shell = callPackage ./cargo-shell { };
  cargo-show-asm = callPackage ./development/tools/cargo-show-asm { };
  cargo-udeps = callPackage ./development/tools/rust/cargo-udeps { };
  catppuccin-cursors = callPackage ./catppuccin-cursors { };
  colmena = callPackage ./colmena { };
  docker-credential-helpers = callPackage ./docker-credential-helpers { };
  doggo = callPackage ./networking/doggo { };
  eza = callPackage ./eza { };
  fd = callPackage ./fd { };
  gh = callPackage ./version-management/gh { };
  git-absorb = callPackage ./version-management/git-absorb { };
  git-interactive-rebase-tool = callPackage ./version-management/git-interactive-rebase-tool { };
  gitui = callPackage ./gitui { };
  glab = callPackage ./glab { };
  gleam = callPackage ./compilers/gleam { };
  jellyfin-media-player = libsForQt5.callPackage ./jellyfin-media-player { };
  kitty = callPackage ./terminal-emulators/kitty { };
  kitty-themes = callPackage ./terminal-emulators/kitty/themes.nix { };
  kubo = callPackage ./kubo { };
  lan-mouse = callPackage ./lan-mouse { };
  mise = callPackage ./mise { };
  minio-client = callPackage ./tools/networking/minio-client { };
  module-server = callPackage ./module-server { };
  mux = callPackage ./mux { };
  nix-update = callPackage ./tools/package-management/nix-update {
    nixfmt = pkgs.nixfmt-rfc-style;
  };
  nixd = callPackage ./nixd {
    llvmPackages = pkgs.llvmPackages_16;
    nix = pkgs.nixVersions.nix_2_19;
  };
  nomad_1_8 = callPackage ./networking/cluster/nomad { };
  npins = callPackage ./npins { };
  obsidian = callPackage ./misc/obsidian { };
  onefetch = callPackage ./onefetch { };
  opentofu = callPackage ./networking/cluster/opentofu { };
  pdm = callPackage ./pdm { };
  pgcli = python3Packages.callPackage ./pgcli { };
  ponysay = callPackage ./ponysay { };
  ptpython = python3Packages.callPackage ./ptpython { };
  pueue = callPackage ./misc/pueue { };
  rustup = callPackage ./rustup { };
  sccache = callPackage ./development/tools/sccache { };
  skopeo = callPackage ./skopeo { };
  starship = callPackage ./starship { };
  stockfish = callPackage ./games/stockfish { };
  trunk = callPackage ./development/tools/trunk { };
  usage = callPackage ./usage { };
  vesktop = callPackage ./vesktop { };
  xh = callPackage ./tools/networking/xh { };
  xinspect = callPackage ./xinspect { };
  yt-dlp = python3Packages.callPackage ./misc/yt-dlp { };
}
