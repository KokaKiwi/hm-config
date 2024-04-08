{ config, pkgs, lib, ... }:
with lib;
let
  settings = fromTOML (config.lib.files.readLocalConfig "starship.toml");
in {
  programs.starship = {
    package = pkgs.starship.override {
      rustPlatform = let
        rustToolchain = with pkgs.fenix; combine [
          stable.rustc
          stable.cargo
        ];
      in pkgs.makeRustPlatform {
        rustc = rustToolchain;
        cargo = rustToolchain;
      };
    };

    catppuccin.enable = true;

    transience = {
      enable = true;
    };

    presets = [ "nerd-font-symbols" ];

    inherit settings;
  };
}
