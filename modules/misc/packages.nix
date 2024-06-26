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
    package = config.lib.package;
  in {
    cool-retro-term = opengl.wrapPackage pkgs.cool-retro-term;
    jellyfin-media-player = opengl.wrapPackage pkgs.jellyfin-media-player;
    minio-client = package.wrapPackage pkgs.minio-client {
      suffix = "-arch";
    } ''
      mv $out/bin/mc $out/bin/mcli
    '';
    npins = pkgs.npins.override {
      # nix = config.nix.package;
    };
    stockfish = pkgs.stockfish.override {
      stdenv = pkgs.llvmStdenv;
      targetArch = "x86-64-bmi2";
    };
    nomad = pkgs.nomad_1_8;
  };
in {
  home.packages = with pkgs; [
    attic-client colmena bitwarden-cli
    eza hexyl pdm pnpm-lock-export
    cargo-shell opentofu gleam mergerfs
    nix-info nurl nixos-option nixfmt-rfc-style
    nix-output-monitor nixd nix-update
    procs skopeo dust rage
    onefetch tokei ast-grep trunk
    ponysay xinspect
    trashy minisign mkcert doggo
    nix-binutils git-absorb pingu
    kiwiPackages.doll
    nur.repos.kokakiwi.go-mod-upgrade
    nur.repos.kokakiwi.lddtree
  ] ++ (lib.attrValues packages);

  env.homePackages = let
    namedPackages = lib.filter (drv: drv ? pname) config.home.packages;
  in builtins.listToAttrs (map (drv: lib.nameValuePair drv.pname drv) namedPackages);
}
