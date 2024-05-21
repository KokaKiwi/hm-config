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

    tree-sitter = {
      enable = true;
      package = pkgs.kiwiPackages.neovim.tree-sitter;
      cc = pkgs.stdenv.cc;
      nodejs = pkgs.nodejs;
    };
  };
}
