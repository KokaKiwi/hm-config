{ pkgs, lib, ... }:
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
    "litecli" "hyfetch"
  ];
  enabledServices = [
    "gpg-agent" "mopidy" "pueue"
    "module-server" "aria2" "kubo"
  ];

  enableNames = flip genAttrs (name: {
    enable = true;
  });
in {
  home.packages = with pkgs; [
    attic-client cachix colmena
    eza hexyl pdm
    cargo-shell opentofu gleam mergerfs
    nil niv nix-info nix-init nurl
    nix-output-monitor nixd
    procs skopeo uv
  ];

  home.sessionVariables = {
    EDITOR = "$(which nvim)";
    ANDROID_HOME = "$HOME/Android/Sdk";
    DEBUGINFOD_URLS = concatStringsSep " " [
      "https://debuginfod.archlinux.org"
      "https://debuginfod.elfutils.org"
    ];
    GHCUP_USE_XDG_DIRS = "true";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cabal/bin"
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
