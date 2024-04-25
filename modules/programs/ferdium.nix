{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.ferdium;

  ferdium = pkgs.nur.repos.kokakiwi.ferdium;
in {
  programs.ferdium = {
    package = pkgs.writeShellScriptBin "ferdium" ''
      ELECTRON_IS_DEV=0 exec /usr/bin/electron ${ferdium}/share/ferdium "$@"
    '';
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

      autostart = true;
    };
  };
}
