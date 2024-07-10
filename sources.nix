let
  system = builtins.currentSystem;

  patches = {
    agenix = [
      ./npins/patches/agenix/0001-Fix-rekey.patch
    ];
    catppuccin = [
      ./npins/patches/catppuccin/0001-Expose-lib.ctp.patch
    ];
  };

  main = import ./npins;
  nur = import ./npins/nur;
  channels = import ./npins/channels;
  lix = let
    version = "2.90.0";
  in {
    lix = fetchTarball {
      name = "source";
      url = "https://git.lix.systems/lix-project/lix/archive/${version}.tar.gz";
      sha256 = "sha256-f8k+BezKdJfmE+k7zgBJiohtS3VkkriycdXYsKOm3sc=";
    };
    nixos-module = fetchTarball {
      name = "source";
      url = "https://git.lix.systems/lix-project/nixos-module/archive/${version}.tar.gz";
      sha256 = "sha256-yEO2cGNgzm9x/XxiDQI+WckSWnZX63R8aJLBRSXtYNE=";
    };
  };

  pkgs = import main.nixpkgs { inherit system; };
  inherit (pkgs) lib;

  applyPatches = lib.mapAttrs (name: source: let
    sourcePatches = patches.${name} or [ ];
  in if sourcePatches == [ ] then source
  else pkgs.srcOnly {
    inherit name;
    src = source;
    patches = sourcePatches;
  });
in applyPatches main // nur // {
  inherit channels lix;
}
