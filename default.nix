{ ... }:
let
  sources = import ./nix;

  pkgs = import sources.nixpkgs {
    overlays = [
      (self: super: import ./pkgs {
        pkgs = self;
        inherit super sources;
      })
    ];

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
in module.activationPackage // {
  inherit module;
  inherit (module) config options pkgs;
}
