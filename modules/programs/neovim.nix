{ pkgs, ... }:
{
  programs.neovim = {
    package = pkgs.kiwiPackages.neovim;

    catppuccin.enable = false;

    defaultEditor = true;

    withRuby = false;

    wrapRc = false;

    viAlias = true;
    vimAlias = true;

    python3Package = pkgs.python312;
  };
}
