{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.ferdium;

  packageLib = config.lib.package;
in {
  programs.ferdium = {
    package = let
      ferdium = pkgs.nur.repos.kokakiwi.ferdium;
      launcher = pkgs.writeShellScript "ferdium" ''
        ELECTRON_IS_DEV=0 exec /usr/bin/electron ${ferdium}/share/ferdium "$@"
      '';
    in packageLib.wrapPackage ferdium { } ''
      rm -f $out/bin/ferdium
      cp -T ${launcher} $out/bin/ferdium
    '';
  };

  xdg.localDesktopEntries = mkIf cfg.enable {
    ferdium = {
      name = "Ferdium";
      exec = "${getExe cfg.package} %U";
      terminal = false;
      icon = "${cfg.package}/share/icons/hicolor/128x128/apps/ferdium.png";
      comment = "Ferdium is your messaging app and combines chat & messaging services into one application.";
      mimeTypes = [ "x-scheme-handler/ferdium" ];
      categories = [ "Network" "InstantMessaging" ];
      startupWMClass = "Ferdium";

      autostart = true;
    };
  };
}
