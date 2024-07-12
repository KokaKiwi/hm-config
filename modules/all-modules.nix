{ lib, ... }:
{
  imports = [
    ./generic/all-modules.nix

    ./lib/package.nix
    ./lib/python.nix

    ./misc/catppuccin.nix
    ./misc/deuxfleurs.nix
    ./misc/editorconfig.nix
    ./misc/files.nix
    ./misc/home.nix
    ./misc/music.nix
    ./misc/nix.nix
    ./misc/opengl.nix
    ./misc/packages.nix
    ./misc/secrets.nix
    ./misc/systemd.nix

    ./programs/aura.nix
    ./programs/bat.nix
    ./programs/bpython.nix
    ./programs/discord.nix
    ./programs/element.nix
    ./programs/fd.nix
    ./programs/ferdium.nix
    ./programs/fish.nix
    ./programs/gh.nix
    ./programs/git.nix
    ./programs/glab.nix
    ./programs/glances.nix
    ./programs/gpg.nix
    ./programs/hyfetch.nix
    ./programs/imhex.nix
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
    ./programs/obsidian.nix
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

    ./services/aria2.nix
    ./services/gpg-agent.nix
    ./services/kubo.nix
    ./services/nix-web.nix
    ./services/pueue.nix
  ]
  ++ lib.optional (builtins.pathExists ./private) ./private;
}
