{ pkgs, super, sources }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // {
    inherit sources;
  });
  importSub = super.lib.callPackageWith {
    inherit pkgs sources;
    inherit (pkgs) lib;
    inherit callPackage importSub;
  };

  makeRustPlatform = rustToolchain: pkgs.makeRustPlatform {
    rustc = rustToolchain;
    cargo = rustToolchain;
  };

  fenixStableToolchain = with pkgs.fenix; combine [
    stable.rustc
    stable.cargo
  ];
  fenixStableRustPlatform = makeRustPlatform fenixStableToolchain;

  applications = importSub ./applications {};
  build-support = importSub ./build-support {};
  data = importSub ./data {};

  packages = applications // build-support // data;

  lib = importSub ./lib {};

  top-level = {
    lib = super.lib // lib;

    fenix = callPackage sources.fenix {};
    inherit fenixStableToolchain fenixStableRustPlatform;

    agenix = callPackage "${sources.agenix}/pkgs/agenix.nix" {
      ageBin = "${pkgs.rage}/bin/rage";
    };

    nur = import sources.nur {
      nurpkgs = pkgs;
      inherit pkgs;
    };

    colmena = callPackage "${sources.colmena}/package.nix" {
      rustPlatform = fenixStableRustPlatform;
    };
    attic-client = callPackage "${sources.attic}/package.nix" {
      rustPlatform = fenixStableRustPlatform;
      clientOnly = true;
    };

    niv = (import sources.niv {}).niv;
  };

  overrides = {
    git-interactive-rebase-tool = (super.git-interactive-rebase-tool.override {
      rustPlatform = fenixStableRustPlatform;
    }).overrideAttrs (prev: {
      postPatch = prev.postPatch + ''
        substituteInPlace src/main.rs src/{config,core,display,input,git,runtime,todo_file,testutils,view}/src/lib.rs \
        --replace "warnings" ""
      '';
    });
  };
in packages // top-level // overrides
