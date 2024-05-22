{ pkgs, super, sources }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // {
    inherit sources;
  });
  importSub = super.lib.callPackageWith {
    inherit pkgs super sources;
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

  applications = importSub ./applications { };
  build-support = importSub ./build-support { };
  data = importSub ./data { };

  kiwiPackages = importSub ./kiwi-packages { };

  packages = applications // build-support // data;

  lib = importSub ./lib { };

  top-level = {
    lib = super.lib // lib;

    inherit kiwiPackages;

    fenix = pkgs.callPackage sources.fenix {};
    inherit fenixStableToolchain fenixStableRustPlatform;

    nur = import sources.nur {
      nurpkgs = pkgs;
      inherit pkgs;
      repoOverrides = {
        kokakiwi = import sources."nur/kokakiwi" {
          inherit pkgs;
        };
      };
    };
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
