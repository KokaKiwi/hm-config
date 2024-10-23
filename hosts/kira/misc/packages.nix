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
    inherit (config.lib) opengl package;
  in {
    cool-retro-term = opengl.wrapPackage pkgs.cool-retro-term { };
    imhex = let
      package = pkgs.nur.repos.kokakiwi.imhex.override {
        inherit (pkgs.kiwiPackages) llvm;
        python3 = pkgs.python312;
      };
    in opengl.wrapPackage package { };
    jellyfin-media-player = opengl.wrapPackage pkgs.jellyfin-media-player { };
    localsend = opengl.wrapPackage pkgs.localsend { };
    minio-client = package.wrapPackage pkgs.minio-client {
      suffix = "-arch";
    } ''
      mv $out/bin/mc $out/bin/mcli
    '';
    obsidian = opengl.wrapPackage pkgs.obsidian { };
    slack = opengl.wrapPackage pkgs.slack { };
    stockfish = pkgs.kiwiPackages.stockfish.override {
      stdenv = pkgs.llvmStdenv;
      targetArch = "x86-64-bmi2";
    };
    nomad = pkgs.nomad_1_9;
    nix-update = pkgs.nix-update.override {
      nix = config.nix.package;
    };
  };
in {
  home.packages = with pkgs; [
    attic-client colmena bitwarden-cli
    eza hexyl pdm
    cargo-shell opentofu gleam mergerfs
    nix-info nurl nixos-option nixfmt-rfc-style
    nix-output-monitor nixd
    procs skopeo dust rage
    onefetch tokei ast-grep trunk
    ponysay xinspect
    trashy minisign mkcert doggo
    nix-binutils git-absorb miniserve
    patool nix-prefetch kx-aspe-cli shellcheck
    bun consul uv b3sum b2sum
    amber-lang fastly npins
    pre-commit sq oxipng
    oha drill deno
    ziggy gitnr binaryen
    nixgl.nixGLIntel

    # Data
    b612 fira-code-nerdfont
  ]
  ++ (with nur.repos; [
    kokakiwi.agree
    kokakiwi.enquirer
    kokakiwi.go-mod-upgrade
    kokakiwi.lddtree
  ])
  ++ (with pkgs.kiwiPackages; [
    doll
  ])
  ++ (lib.attrValues packages);

  env.homePackages = let
    namedPackages = lib.filter (drv: drv ? pname) config.home.packages;
  in builtins.listToAttrs (map (drv: lib.nameValuePair drv.pname drv) namedPackages);
}
