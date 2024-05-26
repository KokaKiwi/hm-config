{ config, pkgs, lib, ... }:
let
  nix-binutils = let
    stdenv = pkgs.stdenv;
    libc = stdenv.cc.libc_bin;

    executables = [ "ldd" "ld.so" ];
  in pkgs.runCommandLocal "nix-binutils-${libc.name}" { } ''
    mkdir -p $out/bin

    for exe in ${toString executables}; do
      ln -s ${libc}/bin/$exe $out/bin/nix-$exe
    done
  '';

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
    nix-info nurl nixos-option
    nix-output-monitor nixd nix-update
    procs skopeo dust rage
    onefetch tokei ast-grep
    ponysay xinspect
    trashy minio-client minisign
    nix-binutils git-absorb
    nur.repos.kokakiwi.go-mod-upgrade
  ] ++ (lib.attrValues packages);
}
