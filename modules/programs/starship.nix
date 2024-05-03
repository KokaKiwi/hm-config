{ config, pkgs, ... }:
let
  settings = fromTOML (config.lib.files.readLocalConfig "starship.toml");
in {
  programs.starship = {
    package = pkgs.starship.override {
      rustPlatform = pkgs.fenixStableRustPlatform;
    };

    transience = {
      enable = true;
    };

    presets = [ "nerd-font-symbols" ];

    inherit settings;
  };
}
