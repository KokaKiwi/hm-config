{ config, pkgs, ... }:
let
  opengl = config.lib.opengl;

  obsidian = opengl.wrapPackage pkgs.obsidian;
in {
  home.packages = [ obsidian ];

  xdg.localDesktopEntries.obsidian = {
    name = "Obsidian";
    icon = "obsidian";
    exec = "${obsidian}/bin/obsidian %U";
    startupWMClass = "Obsidian";
  };
}
