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
    version = "2.90.0-rc1";
  in {
    lix = fetchTarball {
      name = "source";
      url = "https://git.lix.systems/lix-project/lix/archive/${version}.tar.gz";
      sha256 = "sha256-WY7BGnu5PnbK4O8cKKv9kvxwzZIGbIQUQLGPHFXitI0=";
    };
    nixos-module = fetchTarball {
      name = "source";
      url = "https://git.lix.systems/lix-project/nixos-module/archive/${version}.tar.gz";
      sha256 = "sha256-64lB/NO6AQ6z6EDCemPSYZWX/Qc6Rt04cPia5T5v01g=";
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
