let
  system = builtins.currentSystem;

  pkgs = import main.nixpkgs { inherit system; };
  inherit (pkgs) lib callPackage;

  patches = {
    agenix = [
      ./npins/patches/agenix/0001-Fix-rekey.patch
    ];
    catppuccin = [
      ./npins/patches/catppuccin/0001-Expose-lib.ctp.patch
      (pkgs.fetchpatch {
        url = "https://github.com/catppuccin/nix/pull/337.patch";
        hash = "sha256-/p86ah92DVj3CfwuAySvET+5b9G+a9nebE4diJiMCU4=";
      })
    ];
    home-manager = [
      ./npins/patches/home-manager/0001-PR-4801-Add-a-podman-module-for-containers-and-netwo.patch
    ];
  };

  main = import ./npins;
  nur = import ./npins/nur;
  channels = import ./npins/channels;

  lix = callPackage ./pkgs/lix.nix { };

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
