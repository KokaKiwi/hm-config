{ pkgs, sources, callPackage }:
{
  cargo-shell = callPackage ./cargo-shell {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  glab = callPackage ./glab {};
  mise = callPackage ./mise {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  module-server = callPackage ./module-server {};
  mux = callPackage ./mux {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  pdm = callPackage ./pdm {
    python3 = pkgs.python312;
  };
  usage = callPackage ./usage {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
}
