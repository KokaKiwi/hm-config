{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.kitty;
in {
  programs.kitty = {
    package = config.lib.opengl.wrapPackage (pkgs.kitty.override {
      python3 = pkgs.python312;
      python3Packages = pkgs.python312Packages;
    }) { };

    font = {
      name = "FiraCode Nerd Font Mono";
      package = pkgs.fira-code-nerdfont;
      size = 9.5;
    };

    settings = {
      # Fonts
      disable_ligatures = "never";

      # Mouse
      mouse_map = "left click ungrabbed no-op";

      # Performance tuning
      sync_to_monitor = true;

      # Terminal bell
      enable_audio_bell = false;
      bell_on_tab = false;

      # Tab bar
      tab_title_template = "{title.split()[0]}";
      tab_bar_align = "center";

      # Color scheme
      tab_bar_style = "fade";
      tab_fade = "0.33 0.5 1";

      background_opacity = "0.9";

      # Advanced
      editor = "nvim";

      allow_remote_control = "socket-only";
      listen_on = "unix:@kitty";

      term = "xterm-kitty";

      # Tab management
      "map kitty_mod+page_up" = "previous_tab";
      "map kitty_mod+page_down" = "next_tab";
    };
  };

  xdg.localDesktopEntries = mkIf cfg.enable {
    kitty = {
      name = "Kitty";
      genericName = "Terminal emulator";
      icon = "kitty";
      exec = "${getExe cfg.package} --single-instance";
      terminal = false;
      noDisplay = false;
      categories = [ "System" "TerminalEmulator" ];
    };
  };
}
