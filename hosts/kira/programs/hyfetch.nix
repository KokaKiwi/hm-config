{ config, pkgs, ... }:
{
  programs.hyfetch = {
    enable = true;
    package = pkgs.hyfetch.override {
      python3 = pkgs.python312;
    };

    settings = {
      mode = "rgb";
      preset = "nonbinary";
      light_dark = "dark";
      color_align = {
        mode = "horizontal";
      };
    };
  };

  xdg.configFile."neofetch/config".source = pkgs.substituteAll {
    src = config.lib.files.localConfigPath "neofetch.conf";

    inherit (pkgs) gawk pciutils;
    nix = config.nix.package;
  };
}