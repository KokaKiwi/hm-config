{ ... }:
let
  sources = import ./sources.nix;

  pkgs = import sources.nixpkgs {
    overlays = [
      (import "${sources.lix.nixos-module}/overlay.nix" {
        inherit (sources.lix) lix;
      })
      (self: super: import ./pkgs {
        pkgs = self;
        inherit super sources;
      })
    ];

    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "jitsi-meet-1.0.8043"
      ];
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
