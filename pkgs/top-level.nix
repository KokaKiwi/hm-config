{ pkgs, super

, sources

, importSub
}:
let
  nur-kokakiwi = let
    devMode = true;
  in if devMode
  then ../../nur-packages
  else sources."nur/kokakiwi";
in rec {
  lib = super.lib // (importSub ./lib { });

  kiwiPackages = importSub ./kiwi-packages { };
  rustTools = importSub ./rust.nix { };

  stdenv-adapters = import ./stdenv/adapters.nix {
    inherit pkgs;
  };
  mkLLVMStdenv = llvmPackages: lib.pipe llvmPackages.stdenv [
    (stdenv-adapters.overrideBintools llvmPackages.bintools)
    stdenv-adapters.useLLDLinker
  ];
  llvmStdenv = mkLLVMStdenv kiwiPackages.llvmPackages;

  fenix = import sources.fenix {
    inherit pkgs lib;
  };

  craneLib = import sources.crane {
    pkgs = super;
  };
  craneLibStable = craneLib.overrideToolchain rustTools.rust.rustPlatorm;

  nixgl = import sources.nixgl {
    inherit pkgs;
    enable32bits = false;
  };

  zigpkgs = import sources.zig-overlay {
    inherit pkgs;
    inherit (pkgs) system;
  };

  nur = import sources.nur {
    nurpkgs = pkgs;
    inherit pkgs;
    repoOverrides = {
      kokakiwi = import nur-kokakiwi {
        inherit pkgs;
      };
    };
  };
}
