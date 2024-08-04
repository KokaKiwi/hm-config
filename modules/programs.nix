{ ... }:
{
  imports = [
    ./programs/aura.nix
    ./programs/bat.nix
    ./programs/bpython.nix
    ./programs/discord.nix
    ./programs/fd.nix
    ./programs/ferdium.nix
    ./programs/fish.nix
    ./programs/gdb.nix
    ./programs/gh.nix
    ./programs/git.nix
    ./programs/glab.nix
    ./programs/glances.nix
    ./programs/gpg.nix
    ./programs/hyfetch.nix
    ./programs/kde.nix
    ./programs/kitty.nix
    ./programs/lan-mouse.nix
    ./programs/litecli.nix
    ./programs/llvm.nix
    ./programs/mise.nix
    ./programs/mux.nix
    ./programs/neovim.nix
    ./programs/nix-init.nix
    ./programs/nvchecker.nix
    ./programs/paru.nix
    ./programs/password-store.nix
    ./programs/pgcli.nix
    ./programs/powerline.nix
    ./programs/ptpython.nix
    ./programs/rust.nix
    ./programs/sccache.nix
    ./programs/silicon.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/taplo.nix
    ./programs/tmux.nix
    ./programs/xh.nix
    ./programs/yazi.nix
  ];

  programs = {
    aura.enable = true;
    element.enable = true;
    gitui.enable = true;
    glances.enable = true;
    glow.enable = true;
    hub.enable = true;
    nix-index.enable = true;
    sccache.enable = true;
    yt-dlp.enable = true;
    zoxide.enable = true;
  };
}
