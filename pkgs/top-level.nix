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

  mkLLVMStdenv = llvmPackages: lib.pipe llvmPackages.stdenv [
    (adapters.overrideBintools llvmPackages.bintools)
    adapters.useLLDLinker
  ];
in {
  lib = super.lib // (importSub ./lib { });

  kiwiPackages = importSub ./kiwi-packages { };

  stdenv-adapters = adapters;
  inherit mkLLVMStdenv;
  llvmStdenv = mkLLVMStdenv pkgs.llvmPackages_latest;

  fenix = import sources.fenix {
    inherit pkgs lib;
  };
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
