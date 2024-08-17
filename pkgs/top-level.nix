{ pkgs, super, lib

, sources

, importSub
}:
let
  adapters = import ./stdenv/adapters.nix {
    inherit pkgs;
  };

  mkLLVMStdenv = llvmPackages: lib.pipe llvmPackages.stdenv [
    (adapters.overrideBintools llvmPackages.bintools)
    adapters.useLLDLinker
  ];
in {
  lib = super.lib // (importSub ./lib { });

  kiwiPackages = importSub ./kiwi-packages { };
  rustTools = importSub ./rust.nix { };

  stdenv-adapters = adapters;
  inherit mkLLVMStdenv;
  llvmStdenv = mkLLVMStdenv pkgs.llvmPackages_18;

  fenix = import sources.fenix {
    inherit pkgs lib;
  };

  craneLib = import sources.crane {
    pkgs = super;
  };
  craneLibStable = pkgs.craneLib.overrideToolchain pkgs.rustTools.rust.rustPlatorm;

  nixgl = import sources.nixgl {
    inherit pkgs;
    enable32bits = false;
  };

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
