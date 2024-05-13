{ pkgs, sources, ... }:
let
  nix = pkgs.nixVersions.nix_2_22;
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
        systems = [ "x86_64-linux" ];
        identityFile = "/root/.ssh/id_nix";
        maxJobs = 8;
        speedFactor = 5;
      };
      mel = {
        uri = "ssh-ng://mel";
        systems = [ "x86_64-linux" ];
        identityFile = "/root/.ssh/id_nix";
        maxJobs = 4;
        speedFactor = 3;
      };
      nix-alyx = {
        enable = false;
        uri = "ssh://nix-alyx";
        maxJobs = 4;
        speedFactor = 1;
      };
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
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
