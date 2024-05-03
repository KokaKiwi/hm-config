{ config, ... }:
let
  settings = fromTOML (config.lib.files.readLocalConfig "starship.toml");
in {
  programs.starship = {
    transience = {
      enable = true;
    };

    presets = [ "nerd-font-symbols" ];

    inherit settings;
  };
}
