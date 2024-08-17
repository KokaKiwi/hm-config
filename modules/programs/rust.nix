{ pkgs, lib, ... }:
let
  llvmPackages = pkgs.llvmPackages_latest;

  mkStablePackage = drv: drv.override {
    inherit (pkgs.rustTools.rust) rustPlatform;
  };

  cargoPlugins = [
    "about" "binutils" "bloat" "cache" "criterion"
    "nextest" "expand" "deny" "outdated"
    "show-asm" "msrv" "depgraph" "udeps"
    "ndk" "tarpaulin" "pgrx"
    "wipe" "sort" "leptos"
    "c-next" "make" "audit"
  ];
  extraPackages = [
    (pkgs.kiwiPackages.cargo-setup-project.override {
      cargo = "cargo-mommy";
    })
    (mkStablePackage pkgs.nur.repos.kokakiwi.streampager)
  ] ++ (with pkgs; [
    rust-bindgen
  ]);
in {
  home.packages = map (pluginName: pkgs."cargo-${pluginName}") cargoPlugins
    ++ extraPackages;

  programs.rust = {
    cargoConfig = {
      build = {
        jobs = 6;
      };

      alias = {
        gen = "generate";
      };

      target.x86_64-unknown-linux-gnu = {
        linker = "${llvmPackages.clang}/bin/clang";
      };

      profile.dev = {
        opt-level = 0;
        debug = 2;
        incremental = true;
        codegen-units = 512;
      };
      profile.release = {
        opt-level = 3;
        lto = "thin";
        incremental = false;
        codegen-units = 1;
        split-debuginfo = "off";
      };

      registries.crates-io = {
        protocol = "sparse";
      };
    };

    cargo-generate = {
      enable = true;

      config = {
        favorites = let
          templates = {
            leptos = { };
          };
        in lib.mapAttrs (name: config: {
          path = toString ../../files/cargo-templates/${name};
        }) templates;
      };
    };

    cargo-mommy = {
      enable = true;
      package = mkStablePackage pkgs.cargo-mommy;

      enableAlias = true;

      config = {
        roles = "mxtress";
        pronouns = "their";
        little = [ "drone" "doll" "toy" ];
      };
    };
  };
}
