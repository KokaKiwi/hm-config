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
    bun = let
      bun = pkgs.bun;
    in bun.overrideAttrs (self: super: {
      version = "1.1.24";

      buildInputs = [ ];

      src = pkgs.fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${self.version}/bun-linux-x64.zip";
        hash = "sha256-9HiIBnjPKC/dpGzJ1Y4goN3h+tjJz+4Sjq1DmWRT4cg=";
      };
    });
    cool-retro-term = opengl.wrapPackage pkgs.cool-retro-term;
    imhex = let
      package = pkgs.nur.repos.kokakiwi.imhex.override {
        llvm = pkgs.llvm_18;
        python3 = pkgs.python312;
      };
    in opengl.wrapPackage package;
    jellyfin-media-player = opengl.wrapPackage pkgs.jellyfin-media-player;
    minio-client = package.wrapPackage pkgs.minio-client {
      suffix = "-arch";
    } ''
      mv $out/bin/mc $out/bin/mcli
    '';
    npins = pkgs.npins.override {
      # nix = config.nix.package;
    };
    obsidian = opengl.wrapPackage pkgs.obsidian;
    stockfish = pkgs.kiwiPackages.stockfish.override {
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
    nix-binutils git-absorb pingu miniserve
    patool nix-prefetch kx-aspe-cli shellcheck
    nixgl.nixGLIntel
    kiwiPackages.doll
  ]
  ++ (with nur.repos; [
    kokakiwi.enquirer
    kokakiwi.go-mod-upgrade
    kokakiwi.lddtree
  ])
  ++ (lib.attrValues packages);

  env.homePackages = let
    namedPackages = lib.filter (drv: drv ? pname) config.home.packages;
  in builtins.listToAttrs (map (drv: lib.nameValuePair drv.pname drv) namedPackages);
}
