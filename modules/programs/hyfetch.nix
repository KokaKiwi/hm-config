{ pkgs, ... }:
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
}
