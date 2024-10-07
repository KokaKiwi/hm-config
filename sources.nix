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
      "0001-PR-5643-programs.nix-your-shell-add-module.patch"
      "0002-PR-4801-podman-init-module.patch"
      "0003-PR-5905-Nushell-generator.patch"
      "0004-Fixups.patch"
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
    src = source;
    patches = sourcePatches;
    preferLocalBuild = true;
  });
in applyPatches main // nur // {
  inherit channels lix;
}
