{ pkgs, lib, super }:
rec {
  callPackage = lib.callPackageWith (pkgs // {
    craneLib = pkgs.craneLibStable;
    rustPlatform = pkgs.fenixStableRustPlatform;
    inherit python3 python3Packages;
    inherit (pkgs.kiwiPackages) go;
    inherit buildGoModule;
  });

  python3 = pkgs.python312;
  python3Packages = python3.pkgs;

  go = super.go.overrideAttrs rec {
    version = "1.22.4";
    src = pkgs.fetchurl {
      url = "https://go.dev/dl/go${version}.src.tar.gz";
      hash = "sha256-/tcgZ45yinyjC6jR3tHKr+J9FgKPqwIyuLqOIgCPt4Q=";
    };
  };
  buildGoModule = super.buildGoModule.override {
    inherit go;
  };

  neovim = callPackage ./neovim { };
}
