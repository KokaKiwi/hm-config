{ pkgs, lib, super }:
rec {
  callPackage = lib.callPackageWith (pkgs // {
    inherit (pkgs.kiwiPackages) libgit2;
  });
  callPackageIfNewer = path: args: let
    newArgs = builtins.removeAttrs args [ "_overwrite" "_override" ];

    drv = super.${drv'.pname} or null;
    drv' = callPackage path newArgs;

    overwrite = args._overwrite or args._override or false;

    isNewer = drv == null || lib.versionOlder drv.version drv'.version;
    finalDrv = if (isNewer || overwrite) then drv' else drv;
  in finalDrv // {
    local = drv';
    remote = drv;
    isLocal = isNewer || overwrite;
  };
  overrideAttrsIfNewer = drv: fnOrAttrs: let
    drv' = drv.overrideAttrs fnOrAttrs;

    isNewer = lib.versionOlder drv.version drv'.version;
    finalDrv = if isNewer then drv' else drv;
  in finalDrv // {
    local = drv';
    remote = drv;
    isLocal = isNewer;
  };

  python3 = pkgs.python312;
  python3Packages = python3.pkgs;

  inherit (pkgs) go;
  buildGoModule = super.buildGoModule.override {
    inherit go;
  };

  cargo-pgrx = callPackage ./cargo-pgrx { };
  cargo-setup-project = callPackage ./cargo-setup-project { };
  doll = callPackage ./doll { };
  libgit2 = callPackage ./libgit2 { };
  man-db = callPackage ./man-db { };
  neovim = callPackage ./neovim { };
  stockfish = callPackage ./games/stockfish { };
  vscodium = callPackage ./vscodium { };

  llvm = pkgs.llvm_19;
  llvmPackages = pkgs.llvmPackages_19;

  gnupg = overrideAttrsIfNewer super.gnupg24 (self: prev: {
    version = "2.4.6";

    src = pkgs.fetchurl {
      url = "mirror://gnupg/gnupg/${self.pname}-${self.version}.tar.bz2";
      hash = "sha256-laz6/acASSSm9ckBZ38VrBvaJ1RRHZc7tFI+jdhA4Xo=";
    };
  });
}
