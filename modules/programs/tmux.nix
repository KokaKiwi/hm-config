{ config, pkgs, lib, sources, ... }:
with lib;
let
  tmux-loadavg = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-loadavg";
    rtpFilePath = "tmux-loadavg.tmux";
    version = builtins.substring 0 8 sources.tmux-loadavg.revision;
    src = sources.tmux-loadavg;
  };
in {
  programs.tmux = {
    enableSystemd = true;

    catppuccin = {
      extraConfig = config.lib.tmux.formatOptions {
        prefix = "catppuccin_";
      } {
        # Window
        window_current_background = "#1e1e2d";

        window_left_separator = " █";

        window_default_text = " #W ";
        window_current_text = " #W ";

        # Status
        status_modules_left = concatStringsSep " " [
          "session"
        ];
        status_modules_right = concatStringsSep " " [
          "load"
          "date_time"
        ];
        status_left_separator = " ";
        status_right_separator = "";
        status_connect_separator = "no";

        date_time_text = "%H:%M";
      };
    };

    terminal = "tmux-256color";
    mouse = true;
    aggressiveResize = true;
    clock24 = true;
    shortcut = "s";
    escapeTime = 0;
    historyLimit = 50000;
    baseIndex = 1;

    shell = getExe config.programs.fish.package;

    updateEnvironment = [
      "SSH_AUTH_SOCK" "SSH_CONNECTION" "SSH_ASKPASS"
      "GIT_ASKPASS"
      "DISPLAY" "JAVA_HOME"
      "KITTY_INSTALLATIOn_DIR" "KITTY_LISTEN_ON" "KITTY_PID" "KITTY_PUBLIC_KEY" "KITTY_WINDOW_ID"
      "XAUTHORITY" "PINENTRY" "GTK_USE_PORTAL" "GTK_IM_MODULE" "QT_IM_MODULE"
      "XMODIFIERS" "KDE_FULL_SESSION" "KDE_SESSION_UID"
      "TERM" "TERM_PROGRAM"
    ];

    plugins = [
      tmux-loadavg
    ];

    extraConfig = config.lib.files.readLocalConfig "tmux/tmux.conf";
  };
}
