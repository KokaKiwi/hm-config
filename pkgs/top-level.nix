{ pkgs, lib, super, sources, importSub }:
let
  adapters = import ./stdenv/adapters.nix {
    inherit pkgs;
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

  llvmPackages = pkgs.llvmPackages_latest;
  useLLVMBintools = adapters.overrideBintools llvmPackages.bintools;
in {
  lib = super.lib // (importSub ./lib { });

  kiwiPackages = importSub ./kiwi-packages { };

  stdenv-adapters = adapters;
  inherit useLLVMBintools;
  llvmStdenv = lib.pipe llvmPackages.stdenv [
    useLLVMBintools
    adapters.useLLDLinker
  ];

  fenix = pkgs.callPackage sources.fenix {};
  inherit fenixStableToolchain fenixStableRustPlatform;

  craneLib = import sources.crane {
    pkgs = super;
  };
  craneLibStable = pkgs.craneLib.overrideToolchain fenixStableToolchain;

  nur = import sources.nur {
    nurpkgs = pkgs;
    inherit pkgs;
    repoOverrides = {
      kokakiwi = import sources."nur/kokakiwi" {
        inherit pkgs;
      };
    };
  };
}
