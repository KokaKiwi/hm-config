{ config, pkgs, lib, ... }:
let
  packages = let
    opengl = config.lib.opengl;
  in {
    cool-retro-term = opengl.wrapPackage pkgs.cool-retro-term;
    jellyfin-media-player = opengl.wrapPackage pkgs.jellyfin-media-player;
    npins = pkgs.npins.override {
      nix = config.nix.package;
    };
  };
in {
  home.packages = with pkgs; [
    attic-client colmena
    eza hexyl pdm
    cargo-shell opentofu gleam mergerfs
    nix-info nix-init nurl
    nix-output-monitor nixd nix-update
    procs skopeo dust rage
    onefetch tokei ast-grep
    ponysay xinspect
    nur.repos.kokakiwi.go-mod-upgrade
  ] ++ (lib.attrValues packages);
}
