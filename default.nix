{ ... }:
let
  sources = import ./sources.nix;

  pkgs = import sources.nixpkgs {
    overlays = [
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
  inherit (pkgs) lib;

  module = import "${sources.home-manager}/modules" {
    configuration = ./home.nix;

    inherit pkgs;
    check = true;

    extraSpecialArgs = {
      inherit sources;
      actualPkgs = pkgs;
    };
  };

  homePackages = with lib; let
    packages = module.config.home.packages;
    namedPackages = flip filter packages (drv: drv ? pname);
  in builtins.listToAttrs (flip map namedPackages (drv: nameValuePair drv.pname drv));

  env = {
    inherit module;
    inherit (module) config options pkgs;
    inherit homePackages;
  };
in module.activationPackage // env // { inherit env; }
