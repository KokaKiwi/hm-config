{ pkgs, lib, super }:
rec {
  callPackage = lib.callPackageWith (pkgs // {
    inherit (pkgs.kiwiPackages) libgit2;
  });
  callPackageIfNewer = path: args: let
    drv = super.${drv'.pname} or null;
    drv' = callPackage path args;
  in if drv == null || lib.versionOlder drv.version drv'.version
  then drv' // {
    isLocal = true;
    remote = drv;
  }
  else drv // {
    isLocal = false;
    local = drv';
  };

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
  stockfish = callPackage ./games/stockfish { };
}
