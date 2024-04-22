{ ... }:
let
  sources = import ./nix;

  pkgs = import sources.nixpkgs {};
  module = import "${sources.home-manager}/modules" {
    configuration = ./home.nix;

    inherit pkgs;
    check = true;

    extraSpecialArgs = {
      inherit sources;
    };
  };
in module.activationPackage // {
  inherit module;
  inherit (module) config options pkgs;
}
