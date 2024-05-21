{ pkgs, callPackage }:
let
  inherit (pkgs) libsForQt5;

  callRustPackage = path: args: callPackage path (args // {
    rustPlatform = pkgs.fenixStableRustPlatform;
  });

  python3 = pkgs.python312;
  python3Packages = python3.pkgs;
in {
  ast-grep = callRustPackage ./ast-grep { };
  cargo-depgraph = callRustPackage ./cargo-depgraph { };
  cargo-ndk = callRustPackage ./cargo-ndk { };
  cargo-shell = callRustPackage ./cargo-shell { };
  eza = callRustPackage ./eza { };
  fd = callRustPackage ./fd { };
  gitui = callRustPackage ./gitui { };
  glab = callPackage ./glab { };
  jellyfin-media-player = libsForQt5.callPackage ./jellyfin-media-player { };
  mise = callRustPackage ./mise { };
  module-server = callPackage ./module-server { };
  mux = callRustPackage ./mux { };
  npins = callRustPackage ./npins { };
  onefetch = callRustPackage ./onefetch { };
  pdm = callPackage ./pdm {
    inherit python3;
  };
  pgcli = python3Packages.callPackage ./pgcli { };
  ponysay = callPackage ./ponysay { };
  rustup = callRustPackage ./rustup { };
  skopeo = callPackage ./skopeo { };
  starship = callRustPackage ./starship { };
  usage = callRustPackage ./usage { };
  xinspect = callRustPackage ./xinspect { };
}
