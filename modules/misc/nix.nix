{ pkgs, ... }:
let
  sources = import ../../nix;

  nix = pkgs.nixVersions.nix_2_21;
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
        key = "kokakiwi:jjzBrtjfDKJwgyMZjajoQ1dXLa/hCU0iQBPEJhDGN+c=";
      }
    ];
  };
}
