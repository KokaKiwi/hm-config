{ pkgs, super, lib

, sources

, importSub
}:
let
  adapters = import ./stdenv/adapters.nix {
    inherit pkgs;
  };

  makeRustPlatform = rustToolchain: pkgs.makeRustPlatform {
    rustc = rustToolchain;
    cargo = rustToolchain;
  };

  fenixStableToolchain = with pkgs.fenix; let
    toolchain = toolchainOf {
      channel = "1.80.0";
      sha256 = "sha256-6eN/GKzjVSjEhGO9FhWObkRFaE1Jf+uqMSdQnb8lcB4=";
    };
  in combine [
    toolchain.rustc
    toolchain.cargo
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
  llvmStdenv = mkLLVMStdenv pkgs.llvmPackages_18;

  fenix = import sources.fenix {
    inherit pkgs lib;
  };
  inherit fenixStableToolchain fenixStableRustPlatform;

  craneLib = import sources.crane {
    pkgs = super;
  };
  craneLibStable = pkgs.craneLib.overrideToolchain fenixStableToolchain;

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
