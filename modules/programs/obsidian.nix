{ config, pkgs, lib, ... }:
with lib;
let
  opengl = config.lib.opengl;

  obsidian = opengl.wrapPackage pkgs.obsidian;
in {
  home.packages = [ obsidian ];

  xdg.localDesktopEntries.obsidian = {
    name = "Obsidian";
    icon = "obsidian";
    exec = "${getExe obsidian} %U";
    startupWMClass = "Obsidian";
  };
}
