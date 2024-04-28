{ pkgs, super, sources }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // {
    inherit sources;
  });
  importSub = super.lib.callPackageWith {
    inherit pkgs sources;
    inherit (pkgs) lib;
    inherit callPackage importSub;
  };

  makeRustPlatform = rustToolchain: pkgs.makeRustPlatform {
    rustc = rustToolchain;
    cargo = rustToolchain;
  };

  fenixStableToolchain = with pkgs.fenix; combine [
    stable.rustc
    stable.cargo
  ];
  fenixStableRustPlatform = makeRustPlatform fenixStableToolchain;

  applications = importSub ./applications {};
  build-support = importSub ./build-support {};
  data = importSub ./data {};

  packages = applications // build-support // data;

  lib = importSub ./lib {};

  top-level = {
    lib = super.lib // lib;

    fenix = pkgs.callPackage sources.fenix {};
    inherit fenixStableToolchain fenixStableRustPlatform;

    agenix = pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" {
      ageBin = "${pkgs.rage}/bin/rage";
    };

    nur = import sources.nur {
      nurpkgs = pkgs;
      inherit pkgs;
    };

    colmena = pkgs.callPackage "${sources.colmena}/package.nix" {
      rustPlatform = fenixStableRustPlatform;
    };
    attic-client = pkgs.callPackage "${sources.attic}/package.nix" {
      rustPlatform = fenixStableRustPlatform;
      clientOnly = true;
    };

    niv = (import sources.niv {
      inherit pkgs;
    }).niv;
  };

  overrides = {
    git-interactive-rebase-tool = (super.git-interactive-rebase-tool.override {
      rustPlatform = fenixStableRustPlatform;
    }).overrideAttrs (prev: {
      postPatch = prev.postPatch + ''
        substituteInPlace src/main.rs src/{config,core,display,input,git,runtime,todo_file,testutils,view}/src/lib.rs \
        --replace "warnings" ""
      '';
    });
    glfw3 = super.glfw3.overrideAttrs (super: {
      postPatch = super.postPatch + ''
      substituteInPlace src/wl_init.c \
      --replace "libdecor-0.so.0" "${pkgs.lib.getLib pkgs.libdecor}/lib/libdecor-0.so.0"

      substituteInPlace src/wl_init.c \
      --replace "libwayland-client.so.0" "${pkgs.lib.getLib pkgs.wayland}/lib/libwayland-client.so.0"

      substituteInPlace src/wl_init.c \
      --replace "libwayland-cursor.so.0" "${pkgs.lib.getLib pkgs.wayland}/lib/libwayland-cursor.so.0"

      substituteInPlace src/wl_init.c \
      --replace "libwayland-egl.so.1" "${pkgs.lib.getLib pkgs.wayland}/lib/libwayland-egl.so.1"
      '';
    });
  };
in packages // top-level // overrides
