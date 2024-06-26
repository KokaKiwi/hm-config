{ pkgs, lib, sources, ... }:
let
  nix = pkgs.nixVersions.nix_2_23;
in {
  imports = [
    "${sources.declarative-cachix}/home-manager.nix"
  ];

  home.packages = [ nix ];

  nix = {
    package = nix;

    builders = {
      nix-games = {
        uri = "ssh-ng://nix-games";
        systems = [ "x86_64-linux" "aarch64-linux" ];
        identityFile = "/root/.ssh/id_nix";
        maxJobs = 3;
        speedFactor = 5;
      };
      nix-alyx = {
        enable = false;
        uri = "ssh-ng://nix-alyx";
        identityFile = "/root/.ssh/id_nix";
        maxJobs = 1;
        speedFactor = 1;
      };
    };

    channels = let
      names = [ "nixos-23.11" "nixos-24.05" ];
    in {
      nixpkgs = sources.nixpkgs;
      nixpkgs-unstable = sources.nixpkgs;
    } // builtins.listToAttrs (map (name: lib.nameValuePair name sources.channels.${name}) names);
    keepOldNixPath = false;

    settings = {
      extra-platforms = [ "aarch64-linux" ];
      experimental-features = [ "nix-command" "flakes" ];
      use-xdg-base-directories = true;
    };
  };

  caches = {
    cachix = [
      "nix-community"
      "cachix"
      "kokakiwi"
      "niv"
      "colmena"
    ];

    extraCaches = [
      {
        url = "https://attic.bismuth.it/kokakiwi";
        key = "kokakiwi:e3jihe8aS1LCVYET8hAm79TM68DZ3RDsbzPLuvZYEKA=";
      }
      {
        url = "https://cache.lix.systems";
        key = "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=";
      }
    ];
  };
}
