{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.discord;
in {
  programs.discord = {
    flavour = "vesktop";
    package = config.lib.opengl.wrapPackage (pkgs.vesktop.override {
      withTTS = false;
      withSystemVencord = false;
    });
  };

  xdg.localDesktopEntries = mkIf cfg.enable {
    vesktop = {
      name = "Vesktop";
      icon = "vesktop";
      exec = "${getExe cfg.package} %U";
      startupWMClass = "Vesktop";
      keywords = [ "discord" "vencord" "electron" "chat" ];
      categories = [ "Network" "InstantMessaging" "Chat" ];
    };
  };
}
