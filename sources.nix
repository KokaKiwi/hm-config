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

  pkgs = import main.nixpkgs { inherit system; };
  inherit (pkgs) lib;

  applyPatches = sources: lib.flip lib.mapAttrs sources (name: source: let
    sourcePatches = patches.${name} or [ ];
  in if sourcePatches == [ ] then source
  else pkgs.srcOnly {
    inherit name;
    src = source;
    patches = sourcePatches;
  });
in applyPatches main // nur // {
  inherit channels;
}
