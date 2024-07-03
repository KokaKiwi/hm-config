{ ... }:
let
  sources = import ./sources.nix;

  lix = rec {
    version = "2.90.0-rc1";

    lix = fetchTarball {
      name = "source";
      url = "https://git.lix.systems/lix-project/lix/archive/${version}.tar.gz";
      sha256 = "sha256-WY7BGnu5PnbK4O8cKKv9kvxwzZIGbIQUQLGPHFXitI0=";
    };
    nixosModule = fetchTarball {
      name = "source";
      url = "https://git.lix.systems/lix-project/nixos-module/archive/${version}.tar.gz";
      sha256 = "sha256-64lB/NO6AQ6z6EDCemPSYZWX/Qc6Rt04cPia5T5v01g=";
    };

    overlay = import "${nixosModule}/overlay.nix" {
      inherit lix;
    };
  };

  pkgs = import sources.nixpkgs {
    overlays = [
      lix.overlay
      (self: super: import ./pkgs {
        pkgs = self;
        inherit super sources;
      })
    ];

    config = {
      allowUnfree = true;
    };

    localSystem = {
      system = "x86_64-linux";
    };
  };

  module = import "${sources.home-manager}/modules" {
    configuration = ./home.nix;

    inherit pkgs;
    check = true;

    extraSpecialArgs = {
      inherit sources;
      actualPkgs = pkgs;
    };
  };

  env = {
    inherit module sources;
    inherit (module) config options pkgs;
    inherit (module.pkgs) lib;
  } // module.config.env;
in module.activationPackage // env // { inherit env; }
