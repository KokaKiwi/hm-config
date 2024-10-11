{ pkgs, sources }:
let
  inherit (pkgs) libsForQt5 kdePackages rustTools;
  inherit (pkgs.kiwiPackages) python3Packages;
  callPackage = pkgs.kiwiPackages.callPackageIfNewer;
in {
  act = callPackage ./development/tools/act { };
  activate-linux = callPackage ./misc/activate-linux {
    _overwrite = true;
  };
  agenix = callPackage "${sources.agenix}/pkgs/agenix.nix" { };
  amber-lang = callPackage ./development/compilers/amber-lang { };
  ast-grep = callPackage ./development/tools/ast-grep { };
  attic-client = callPackage ./tools/networking/attic-client {
    nix = pkgs.nixVersions.nix_2_18_upstream;
  };
  bitwarden-cli = callPackage ./misc/bitwarden-cli { };
  cargo-about = callPackage ./development/tools/cargo-about { };
  cargo-c-next = callPackage ./development/tools/rust/cargo-c { };
  cargo-component = callPackage ./development/tools/rust/cargo-component { };
  cargo-deny = callPackage ./development/tools/rust/cargo-deny { };
  cargo-depgraph = callPackage ./development/tools/rust/cargo-depgraph { };
  cargo-expand = callPackage ./development/tools/rust/cargo-expand { };
  cargo-generate = callPackage ./development/tools/rust/cargo-generate { };
  cargo-leptos = callPackage ./development/tools/rust/cargo-leptos { };
  cargo-make = callPackage ./development/tools/rust/cargo-make { };
  cargo-ndk = callPackage ./development/tools/rust/cargo-ndk { };
  cargo-nextest = callPackage ./development/tools/rust/cargo-nextest { };
  cargo-shell = callPackage ./development/tools/rust/cargo-shell { };
  cargo-show-asm = callPackage ./development/tools/cargo-show-asm { };
  cargo-tarpaulin = callPackage ./development/tools/analysis/cargo-tarpaulin { };
  cargo-udeps = callPackage ./development/tools/rust/cargo-udeps { };
  catppuccin-cursors = callPackage ./misc/catppuccin-cursors { };
  colmena = callPackage ./networking/cluster/colmena { };
  consul = callPackage ./tools/admin/consul { };
  delta = callPackage ./version-management/delta { };
  deno = callPackage ./development/deno { };
  docker-credential-helpers = callPackage ./misc/docker-credential-helpers { };
  doggo = callPackage ./networking/doggo { };
  du-dust = pkgs.dust;
  dust = callPackage ./misc/dust { };
  eza = callPackage ./misc/eza { };
  fastfetch = callPackage ./misc/fastfetch {
    stdenv = pkgs.llvmStdenv;
  };
  fastly = callPackage ./misc/fastly { };
  fd = callPackage ./misc/fd { };
  gh = callPackage ./version-management/gh { };
  git-absorb = callPackage ./version-management/git-absorb { };
  git-cliff = callPackage ./version-management/git-cliff {
    _overwrite = true;
    inherit (rustTools.rust) rustPlatform;
  };
  git-interactive-rebase-tool = callPackage ./version-management/git-interactive-rebase-tool { };
  gitui = callPackage ./misc/gitui { };
  glab = callPackage ./misc/glab {
    buildGoModule = pkgs.buildGo123Module;
  };
  gleam = callPackage ./compilers/gleam { };
  glow = callPackage ./editors/glow { };
  jellyfin-media-player = libsForQt5.callPackage ./misc/jellyfin-media-player { };
  kitty = callPackage ./terminal-emulators/kitty {
    go = pkgs.go_1_23;
    buildGoModule = pkgs.buildGo123Module;
  };
  kitty-themes = callPackage ./terminal-emulators/kitty/themes.nix { };
  kubo = callPackage ./networking/kubo { };
  lan-mouse = callPackage ./misc/lan-mouse { };
  litecli = callPackage ./development/tools/database/litecli { };
  mise = callPackage ./development/tools/mise { };
  minio-client = callPackage ./tools/networking/minio-client { };
  miniserve = callPackage ./tools/misc/miniserve {
    inherit (rustTools.rust_1_81) rustPlatform;
  };
  module-server = callPackage ./misc/module-server { };
  mux = callPackage ./misc/mux { };
  ncmpcpp = callPackage ./audio/ncmpcpp { };
  nix-update = callPackage ./tools/package-management/nix-update {
    nixfmt = pkgs.nixfmt-rfc-style;
  };
  nixd = callPackage ./development/tools/nixd {
    llvmPackages = pkgs.llvmPackages_16;
    nix = pkgs.nixVersions.nix_2_19;
  };
  nomad_1_8 = callPackage ./networking/cluster/nomad/1_8.nix { };
  nomad_1_9 = callPackage ./networking/cluster/nomad/1_9.nix { };
  npins = callPackage ./development/tools/npins { };
  obsidian = callPackage ./misc/obsidian { };
  onefetch = callPackage ./misc/onefetch { };
  opentofu = callPackage ./networking/cluster/opentofu { };
  patool = callPackage ./misc/patool { };
  pdm = callPackage ./development/tools/pdm { };
  pgcli = python3Packages.callPackage ./development/tools/pgcli { };
  ponysay = callPackage ./misc/ponysay { };
  pre-commit = callPackage ./tools/misc/pre-commit { };
  procs = callPackage ./tools/admin/procs { };
  ptpython = python3Packages.callPackage ./development/tools/ptpython { };
  pueue = callPackage ./misc/pueue { };
  rustup = callPackage ./development/tools/rustup { };
  silicon = callPackage ./misc/silicon { };
  skopeo = callPackage ./tools/misc/skopeo { };
  starship = callPackage ./tools/misc/starship { };
  syncthing = callPackage ./networking/syncthing { };
  syncthingtray = kdePackages.callPackage ./misc/syncthingtray { };
  szurubooru-cli = callPackage ./misc/booru-cli { };
  taplo = callPackage ./development/tools/taplo { };
  tmux = callPackage ./tools/misc/tmux { };
  trunk = callPackage ./development/tools/trunk { };
  usage = callPackage ./tools/usage { };
  uv = callPackage ./development/tools/uv {
    inherit (rustTools.rust_1_81) rustPlatform rustc cargo;
  };
  vesktop = callPackage ./misc/vesktop { };
  wasm-tools = callPackage ./tools/misc/wasm-tools { };
  wit-bindgen = callPackage ./development/tools/rust/wit-bindgen { };
  xh = callPackage ./tools/networking/xh { };
  xinspect = callPackage ./development/tools/xinspect { };
  yt-dlp = python3Packages.callPackage ./misc/yt-dlp { };
  ziggy = callPackage ./development/tools/ziggy { };
  zoxide = callPackage ./tools/misc/zoxide { };
}
