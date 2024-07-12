{ pkgs, ... }:
let
  llvmPackages = pkgs.llvmPackages_latest;

  toml = pkgs.formats.toml { };

  mkStablePackage = drv: drv.override {
    rustPlatform = pkgs.fenixStableRustPlatform;
  };

  cargoPlugins = [
    "about" "binutils" "bloat" "cache" "criterion"
    "nextest" "expand" "deny" "outdated"
    "show-asm" "msrv" "depgraph" "udeps"
    "ndk" "tarpaulin" "pgrx"
    "wipe" "sort" "generate" "leptos"
    "c"
  ];
  extraPackages = [
    (pkgs.kiwiPackages.cargo-setup-project.override {
      cargo = "cargo-mommy";
    })
  ];

  cargoConfig = {
    build = {
      jobs = 6;
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
in {
  home.packages =
    [ pkgs.rustup ]
    ++ map (pluginName: mkStablePackage pkgs."cargo-${pluginName}") cargoPlugins
    ++ extraPackages;

  home.file.".cargo/config.toml".source = toml.generate "cargo-config.toml" cargoConfig;

  programs.rust = {
    cargo-mommy = {
      enable = true;
      package = mkStablePackage pkgs.cargo-mommy;

      enableAlias = true;

      config = {
        little = [ "drone" "doll" "toy" ];
      };
    };
  };
}
