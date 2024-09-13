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

    tree-sitter = let
      cc = pkgs.stdenv.cc;
    in {
      enable = true;
      package = pkgs.kiwiPackages.neovim.tree-sitter;
      cc = "${cc}/bin/cc";
      nodejs = pkgs.nodejs;
    };
  };
}
