{ config, pkgs, ... }:
{
  services.espanso = {
    enable = true;
    package = with config.lib; let
      espanso = pkgs.espanso-wayland.override {
        inherit (pkgs.rustTools.stable) rustPlatform;
      };
    in opengl.wrapPackage espanso { };

    configs = {
      default = {
        keyboard_layout = {
          layout = "fr";
        };
      };
    };

    matches = {
      base = { };
    };
  };
}
