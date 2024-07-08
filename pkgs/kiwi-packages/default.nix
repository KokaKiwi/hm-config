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

  inherit (pkgs) go;
  buildGoModule = super.buildGoModule.override {
    inherit go;
  };

  cargo-setup-project = callPackage ./cargo-setup-project { };
  doll = callPackage ./doll { };
  neovim = callPackage ./neovim { };
}
