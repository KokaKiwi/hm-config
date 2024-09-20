{ config, pkgs, ... }:
let
  inherit (config.lib) opengl;
in {
  programs.element = {
    enable = true;

    package = opengl.wrapPackage pkgs.element-desktop-wayland;
  };
}
