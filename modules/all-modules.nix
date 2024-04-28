{
  imports = [
    ./generic/all-modules.nix

    ./misc/catppuccin.nix
    ./misc/deuxfleurs.nix
    ./misc/files.nix
    ./misc/home.nix
    ./misc/music.nix
    ./misc/nix.nix
    ./misc/nixpkgs.nix
    ./misc/opengl.nix
    ./misc/secrets.nix
    ./misc/systemd.nix

    ./programs/bat.nix
    ./programs/discord.nix
    ./programs/element.nix
    ./programs/ferdium.nix
    ./programs/fish.nix
    ./programs/gh.nix
    ./programs/git.nix
    ./programs/glab.nix
    ./programs/gpg.nix
    ./programs/imhex.nix
    ./programs/kitty.nix
    ./programs/litecli.nix
    ./programs/mise.nix
    ./programs/mux.nix
    ./programs/nvchecker.nix
    ./programs/paru.nix
    ./programs/password-store.nix
    ./programs/pgcli.nix
    ./programs/powerline.nix
    ./programs/ssh.nix
    ./programs/starship.nix
    ./programs/taplo.nix
    ./programs/tmux.nix
    ./programs/yazi.nix
    ./programs/yt-dlp.nix

    ./services/aria2.nix
    ./services/gpg-agent.nix
    ./services/kubo.nix
    ./services/pueue.nix
  ];
}
