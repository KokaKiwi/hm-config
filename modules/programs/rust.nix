{ pkgs, ... }:
let
  llvmPackages = pkgs.llvmPackages_latest;

  toml = pkgs.formats.toml { };

  cargoPlugins = [
    "about" "binutils" "bloat" "cache" "criterion"
    "nextest" "expand" "deny" "outdated"
    "show-asm" "msrv" "depgraph" "udeps"
    "ndk" "mommy" "tarpaulin" "pgrx"
    "wipe"
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
    ++ map (pluginName: pkgs."cargo-${pluginName}".override {
      rustPlatform = pkgs.fenixStableRustPlatform;
    }) cargoPlugins;

  home.file.".cargo/config.toml".source = toml.generate "cargo-config.toml" cargoConfig;
}
