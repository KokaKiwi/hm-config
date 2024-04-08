{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.ferdium;
in {
  programs.ferdium = {
    package = config.lib.opengl.wrapPackage pkgs.ferdium-electron {};
  };

  xdg.localDesktopEntries = mkIf cfg.enable {
    ferdium = {
      name = "Ferdium";
      exec = "${getExe cfg.package} %U";
      terminal = false;
      icon = "ferdium";
      comment = "Ferdium is your messaging app and combines chat & messaging services into one application.";
      mimeTypes = [ "x-scheme-handler/ferdium" ];
      categories = [ "Network" "InstantMessaging" ];
      startupWMClass = "Ferdium";
    };
  };
}
