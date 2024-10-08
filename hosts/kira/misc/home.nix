{ config, lib, ... }:
{
  home.sessionVariables = {
    ANDROID_HOME = "$HOME/Android/Sdk";
    DEBUGINFOD_URLS = lib.concatStringsSep " " [
      "https://debuginfod.archlinux.org"
      "https://debuginfod.elfutils.org"
    ];
    GHCUP_USE_XDG_DIRS = "true";
    BW_SESSION = "$(cat \"${config.age.secrets.bitwarden-session-key.path}\" | tr -d \\n)";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
  ];

  home.shellAliases = {
    ls = "eza -g";
    ll = "eza -gl";

    tnew = "tmux new -ADs";

    elfcomment = "readelf -p .comment";
  };

  home.shell = {
    package = config.programs.fish.package;
    exeName = "fish";
  };

  fonts.fontconfig.enable = true;
}
