{ pkgs, lib }:
let
  makeRustPlatform = rustToolchain: pkgs.makeRustPlatform {
    rustc = rustToolchain;
    cargo = rustToolchain;
  };

  versions = rec {
    rust_1_79 = {
      channel = "1.79.0";
      hash = "sha256-Ngiz76YP4HTY75GGdH2P+APE/DEIx2R/Dn+BwwOyzZU=";
    };
    rust_1_80 = {
      channel = "1.80.1";
      hash = "sha256-3jVIIf5XPnUU1CRaTyAiO0XHVbJl12MSx3eucTXCjtE=";
    };
    rust_1_81 = {
      channel = "1.81.0";
      hash = "sha256-VZZnlyP69+Y3crrLHQyJirqlHrTtGTsyiSnZB8jEvVo=";
    };

    rust = rust_1_80;
  };

  rustToolchains = let
    mkToolchain = {
      channel,
      hash ? lib.fakeHash,
      extraComponents ? [ ],
    }: with pkgs.fenix; let
      toolchain = toolchainOf {
        inherit channel;
        sha256 = hash;
      };
    in combine ([
      toolchain.rustc
      toolchain.cargo
      toolchain.rust-src
    ] ++ map (componentName: toolchain.${componentName}) extraComponents);
  in lib.mapAttrs (name: attrs:
    mkToolchain attrs
  ) versions;

  rustPlatforms = lib.mapAttrs (name: attrs:
    makeRustPlatform rustToolchains.${name}
  ) versions;
in {
  inherit rustToolchains rustPlatforms;
} // lib.mapAttrs (name: attrs: {
  rustPlatform = rustPlatforms.${name};
  rustToolchain = rustToolchains.${name};
}) versions
