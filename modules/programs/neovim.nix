{ pkgs, ... }:
{
  programs.neovim = {
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    python3Package = pkgs.python312;
  };
}
