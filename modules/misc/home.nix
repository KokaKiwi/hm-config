{ lib, ... }:
with lib;
let
  enabledPrograms = [
    "bat" "beets" "fish" "gh" "gitui"
    "hub" "kitty" "mise" "mux" "ncmpcpp"
    "ssh" "starship" "tmux" "taplo"
    "paru" "zoxide" "yazi" "git" "gpg"
    "nix-index" "discord" "glow" "glab"
    "password-store" "pgcli" "yt-dlp"
    "nvchecker" "element" "ferdium"
    "litecli" "hyfetch" "fd" "neovim"
    "xh" "nix-init" "sccache"
  ];
  enabledServices = [
    "gpg-agent" "mopidy" "pueue"
    "module-server" "aria2" "kubo"
    "sccache"
  ];

  enableNames = flip genAttrs (name: {
    enable = true;
  });
in {
  home.sessionVariables = {
    ANDROID_HOME = "$HOME/Android/Sdk";
    DEBUGINFOD_URLS = concatStringsSep " " [
      "https://debuginfod.archlinux.org"
      "https://debuginfod.elfutils.org"
    ];
    GHCUP_USE_XDG_DIRS = "true";
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
  };

  fonts.fontconfig.enable = true;

  programs = enableNames enabledPrograms;
  services = enableNames enabledServices;
}
