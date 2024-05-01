{ pkgs, super, callPackage }:
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

  vesktop = super.vesktop.overrideAttrs (super: rec {
    version = "1.5.2";

    src = pkgs.fetchFromGitHub {
      owner = "Vencord";
      repo = "Vesktop";
      rev = "v${version}";
      hash = "sha256-cZOyydwpIW9Xq716KVi1RGtSlgVnOP3w8vXDwouS70E=";
    };

    pnpmDeps = super.pnpmDeps.overrideAttrs {
      outputHash = "sha256-6ezEBeYmK5va3gCh00YnJzZ77V/Ql7A3l/+csohkz68=";
    };
  });
}
