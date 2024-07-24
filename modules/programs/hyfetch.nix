{ config, pkgs, ... }:
{
  programs.hyfetch = {
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

  programs.fastfetch = {
    enable = true;
    package = pkgs.fastfetch.override {
      x11Support = true;
    };
    settings = {
      display = {
        binaryPrefix = "si";
      };
    };
  };

  xdg.configFile."neofetch/config".source = pkgs.substituteAll {
    src = config.lib.files.localConfigPath "neofetch.conf";

    inherit (pkgs) gawk pciutils;
    nix = config.nix.package;
  };
}
