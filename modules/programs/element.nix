{ config, lib, ... }:
with lib;
let
  cfg = config.programs.element;
in {
  programs.element = {};

  xdg.localDesktopEntries = mkIf cfg.enable {
    element-desktop = {
      name = "Element";
      comment = "Feature-rich client for Matrix";
      icon = "element";
      exec = "${getExe cfg.package} %U";
      startupWMClass = "Element";
      mimeTypes = [ "x-scheme-handler/element" ];
      categories = [ "Network" "InstantMessaging" "Chat" ];

      autostart = true;
    };
  };
}
