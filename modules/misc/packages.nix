{ config, pkgs, lib, ... }:
let
  packages = let
    opengl = config.lib.opengl;
  in {
    npins = pkgs.npins.override {
      nix = config.nix.package;
    };
    jellyfin-media-player = opengl.wrapPackage pkgs.jellyfin-media-player;
  };
in {
  home.packages = with pkgs; [
    attic-client colmena
    eza hexyl pdm
    cargo-shell opentofu gleam mergerfs
    nix-info nix-init nurl
    nix-output-monitor nixd nix-update
    procs skopeo uv
    onefetch tokei ast-grep
    nur.repos.kokakiwi.go-mod-upgrade
  ] ++ (lib.attrValues packages);
}
