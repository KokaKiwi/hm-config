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

  craneLibStable = pkgs.craneLib.overrideToolchain fenixStableToolchain;

  llvmPackages = pkgs.llvmPackages_latest;
  useLLVMBintools = adapters.overrideBintools llvmPackages.bintools;
  llvmStdenv = pkgs.lib.pipe llvmPackages.stdenv [
    useLLVMBintools
    adapters.useLLDLinker
  ];

  adapters = import ./stdenv/adapters.nix {
    inherit pkgs;
  };

  applications = importSub ./applications { };
  build-support = importSub ./build-support { };
  data = importSub ./data { };

  kiwiPackages = importSub ./kiwi-packages { };

  packages = applications // build-support // data;

  lib = importSub ./lib { };

  top-level = {
    lib = super.lib // lib;

    inherit kiwiPackages;

    stdenv-adapters = adapters;
    inherit useLLVMBintools llvmStdenv;

    fenix = pkgs.callPackage sources.fenix {};
    inherit fenixStableToolchain fenixStableRustPlatform;

    craneLib = import sources.crane {
      pkgs = super;
    };
    inherit craneLibStable;

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
          --replace-warn "warnings" ""
      '';
    });

    glfw3 = super.glfw3.overrideAttrs (super: {
      postPatch = super.postPatch + ''
      substituteInPlace src/wl_init.c \
        --replace-warn "libdecor-0.so.0" "${pkgs.lib.getLib pkgs.libdecor}/lib/libdecor-0.so.0" \
        --replace-warn "libwayland-client.so.0" "${pkgs.lib.getLib pkgs.wayland}/lib/libwayland-client.so.0" \
        --replace-warn "libwayland-cursor.so.0" "${pkgs.lib.getLib pkgs.wayland}/lib/libwayland-cursor.so.0" \
        --replace-warn "libwayland-egl.so.1" "${pkgs.lib.getLib pkgs.wayland}/lib/libwayland-egl.so.1"
      '';
    });

    imhex = super.imhex.overrideAttrs (super: {
      patches = (super.patches or [ ]) ++ [
        ./patches/imhex.patch
      ];

      meta.mainProgram = "imhex";
    });

    trashy = super.trashy.overrideAttrs {
      postInstall = ''
        $out/bin/trash manpage > trash.1
        installManPage trash.1
      '';
    };
  };
in packages // top-level // overrides
