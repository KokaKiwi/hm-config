{ ... }:
let
  sources = import ./sources.nix;

  pkgs = import sources.nixpkgs {
    overlays = [
      (import "${sources.lix.nixos-module}/overlay.nix" {
        inherit (sources.lix) lix;
      })
      ((import sources.nix-vscode-extensions).overlays.default)
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

  mkModule = hostname: host: let
    configuration = host.configuration or ./hosts/${hostname}/home.nix;

    module = import "${sources.home-manager}/modules" {
      configuration = { lib, ... }: {
        imports = [
          ./modules
          configuration
        ]
        ++ pkgs.nur.repos.kokakiwi.modules.home-manager.all-modules;

        _module.args = {
          pkgs = lib.mkForce pkgs;
        };
      };

      inherit pkgs;
      check = true;

      extraSpecialArgs = {
        inherit sources;

        secretsPath = ./secrets;
      } // (host.extraSpecialArgs or { });
    };

    env = {
      inherit module sources;
      inherit (module) config options pkgs;
      inherit (module.pkgs) lib;
    } // module.config.env;
  in module.activationPackage // env // {
    inherit env;
  };

  hosts = import ./hosts {
    inherit pkgs lib;
  };
in {
  inherit sources pkgs lib;

  hosts = lib.mapAttrs mkModule hosts;
}
