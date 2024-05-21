{ pkgs, callPackage }:
let
  inherit (pkgs) libsForQt5;

  python3 = pkgs.python312;
  python3Packages = python3.pkgs;
in {
  ast-grep = callPackage ./ast-grep {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  cargo-shell = callPackage ./cargo-shell {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  eza = callPackage ./eza {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  fd = callPackage ./fd {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  gitui = callPackage ./gitui {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  glab = callPackage ./glab { };
  jellyfin-media-player = libsForQt5.callPackage ./jellyfin-media-player { };
  mise = callPackage ./mise {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  module-server = callPackage ./module-server { };
  mux = callPackage ./mux {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  npins = callPackage ./npins {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  onefetch = callPackage ./onefetch {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  pdm = callPackage ./pdm {
    inherit python3;
  };
  pgcli = python3Packages.callPackage ./pgcli { };
  ponysay = callPackage ./ponysay { };
  rustup = callPackage ./rustup {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  skopeo = callPackage ./skopeo { };
  starship = callPackage ./starship {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  usage = callPackage ./usage {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
}
