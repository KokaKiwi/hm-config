{ lib, ... }:
{
  imports = [
    ./generic

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
    ./misc/xdg.nix

    ./programs.nix
    ./services.nix
  ]
  ++ lib.optional (builtins.pathExists ./private) ./private;
}
