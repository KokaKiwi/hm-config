{ pkgs, lib, super }:
rec {
  callPackage = lib.callPackageWith (pkgs // {
    inherit callPackage;
    craneLib = pkgs.craneLibStable;
    rustPlatform = pkgs.fenixStableRustPlatform;
    inherit (pkgs.kiwiPackages) python3 python3Packages;
    inherit (pkgs.kiwiPackages) go buildGoModule;
    inherit (pkgs.kiwiPackages) libgit2;
  });

  python3 = pkgs.python312;
  python3Packages = python3.pkgs;

  inherit (pkgs) go;
  buildGoModule = super.buildGoModule.override {
    inherit go;
  };

  cargo-setup-project = callPackage ./cargo-setup-project { };
  doll = callPackage ./doll { };
  libgit2 = callPackage ./libgit2 { };
  neovim = callPackage ./neovim { };
}
