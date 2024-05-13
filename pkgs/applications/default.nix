{ pkgs, super, callPackage }:
let
  inherit (pkgs) haskellPackages;
in {
  ast-grep = callPackage ./ast-grep {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  cargo-shell = callPackage ./cargo-shell {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  fd = callPackage ./fd {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  glab = callPackage ./glab { };
  mise = callPackage ./mise {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  module-server = callPackage ./module-server { };
  mux = callPackage ./mux {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  niv = haskellPackages.callPackage ./niv { };
  onefetch = callPackage ./onefetch {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  pdm = callPackage ./pdm {
    python3 = pkgs.python312;
  };
  usage = callPackage ./usage {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
}
