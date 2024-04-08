{ ... }:
let
  sources = import ./nix;

  pkgs = import sources.nixpkgs {};
  env = import "${sources.home-manager}/modules" {
    configuration = ./home.nix;

    inherit pkgs;
    check = true;

    extraSpecialArgs = {
      inherit sources;
    };
  };
in {
  inherit (env) activationPackage config;
}
