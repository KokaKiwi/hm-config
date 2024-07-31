{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs.kiwiPackages.neovim;

    defaultEditor = true;

    catppuccin.enable = false;

    withRuby = false;

    wrapRc = false;

    viAlias = true;
    vimAlias = true;

    python3Package = pkgs.python312;

    tree-sitter = {
      enable = true;
      package = pkgs.kiwiPackages.neovim.tree-sitter;
      cc = "${pkgs.gcc}/bin/gcc";
      nodejs = pkgs.nodejs;
    };
  };
}
