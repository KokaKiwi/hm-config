{ config, pkgs, ... }:
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

    transience = {
      enable = true;
    };

    presets = [ "nerd-font-symbols" ];

    inherit settings;
  };
}
