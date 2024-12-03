let
  system = builtins.currentSystem;

  pkgs = import main.nixpkgs { inherit system; };
  inherit (pkgs) lib callPackage;

  patches = {
    agenix = [
      "0001-Fix-rekey.patch"
    ];
    catppuccin = [
      "0001-Expose-lib.ctp.patch"
    ];
    home-manager = [
      "0001-PR-5957-espanso-add-sandboxing-for-systemd-service.patch"
    ];
  };

  main = import ./npins;
  nur = import ./npins/nur;
  channels = import ./npins/channels;

  lix = callPackage ./pkgs/lix.nix { };

  applyPatches = lib.mapAttrs (name: source: let
    sourcePatches = map (fileName:
      ./npins/patches/${name}/${fileName}
    ) (patches.${name} or [ ]);
  in if sourcePatches == [ ] then source
  else pkgs.srcOnly {
    inherit name;
    stdenv = pkgs.stdenvNoCC;
    src = source;
    patches = sourcePatches;
    preferLocalBuild = true;
  });
in applyPatches main // nur // {
  inherit channels lix;
}
