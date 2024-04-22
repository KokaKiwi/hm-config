{ pkgs, sources, callPackage }:
{
  ferdium-app = callPackage ./ferdium {};
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
  paru = callPackage ./paru {
    git = pkgs.gitMinimal;
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  taplo = callPackage ./taplo {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
  usage = callPackage ./usage {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };
}
