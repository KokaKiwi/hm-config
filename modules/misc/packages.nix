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
    trashy = let
      base = pkgs.trashy.override {
        rustPlatform = pkgs.fenixStableRustPlatform;
      };
    in base.overrideAttrs (super: {
      postInstall = ''
        $out/bin/trash manpage > trash.1
        installManPage trash.1
      '';
    });
  };
in {
  home.packages = with pkgs; [
    attic-client colmena
    eza hexyl pdm
    cargo-shell opentofu gleam mergerfs
    nix-info nix-init nurl
    nix-output-monitor nixd nix-update
    procs skopeo dust
    onefetch tokei ast-grep
    ponysay xinspect
    nur.repos.kokakiwi.go-mod-upgrade
  ] ++ (lib.attrValues packages);
}
