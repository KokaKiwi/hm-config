{ config, pkgs, lib, ... }:
with lib;
let
  desktopAction = types.submodule ({ name, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
      };

      exec = mkOption {
        type = with types; nullOr (either str path);
        default = null;
      };

      icon = mkOption {
        type = with types; nullOr (either str path);
        default = null;
      };
    };
  });

  desktopEntry = types.submodule {
    options = {
      type = mkOption {
        type = types.enum [ "Application" "Link" "Directory" ];
        default = "Application";
      };

      name = mkOption {
        type = types.str;
      };

      genericName = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      noDisplay = mkOption {
        type = with types; nullOr bool;
        default = null;
      };

      comment = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      icon = mkOption {
        type = with types; nullOr (either str path);
        default = null;
      };

      onlyShowIn = mkOption {
        type = with types; listOf str;
        default = [ ];
      };
      notShowIn = mkOption {
        type = with types; listOf str;
        default = [ ];
      };

      dbusActivatable = mkOption {
        type = with types; nullOr bool;
        default = null;
      };

      tryExec = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      exec = mkOption {
        type = with types; nullOr (either str path);
        default = null;
      };
      path = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      terminal = mkOption {
        type = with types; nullOr bool;
        default = null;
      };

      actions = mkOption {
        type = types.attrsOf desktopAction;
        default = { };
      };

      mimeTypes = mkOption {
        type = with types; listOf str;
        default = [ ];
      };

      categories = mkOption {
        type = with types; listOf str;
        default = [ ];
      };

      implements = mkOption {
        type = with types; listOf str;
        default = [ ];
      };

      keywords = mkOption {
        type = with types; listOf str;
        default = [ ];
      };

      startupNotify = mkOption {
        type = with types; nullOr bool;
        default = null;
      };

      startupWMClass = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      url = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      prefersNonDefaultGPU = mkOption {
        type = with types; nullOr bool;
        default = null;
      };

      extraConfig = mkOption {
        type = with types; attrsOf (oneOf [ str path int ]);
        default = { };
      };

      autostart = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  makeDesktopItem = name: entry: let
    args = (builtins.removeAttrs entry [ "name" "autostart" ]) // {
      inherit name;
      desktopName = entry.name;
    };
  in pkgs.makeDesktopItem args // {
    desktopEntry = entry;
  };

  desktopItems = mapAttrs makeDesktopItem config.xdg.localDesktopEntries;
in {
  options.xdg.localDesktopEntries = mkOption {
    type = types.attrsOf desktopEntry;
    default = { };
  };

  config = mkIf (config.xdg.localDesktopEntries != { }) {
    xdg.configFile = let
      autostartDesktopItems = filterAttrs (name: desktopItem: desktopItem.desktopEntry.autostart) desktopItems;
    in mapAttrs' (name: desktopItem: {
      name = "autostart/${name}.desktop";
      value.source = "${desktopItem}/share/applications/${name}.desktop";
    }) autostartDesktopItems;

    xdg.dataFile = mapAttrs' (name: desktopItem: {
      name = "applications/${name}.desktop";
      value.source = "${desktopItem}/share/applications/${name}.desktop";
    }) desktopItems;

    home.activation.xdgDesktopEntriesUpdate = hm.dag.entryAfter [ "linkGeneration" ] ''
      verboseEcho "Updating the desktop file cache..."
      run ${pkgs.buildPackages.desktop-file-utils}/bin/update-desktop-database ${config.xdg.dataHome}/applications
    '';
  };
}
