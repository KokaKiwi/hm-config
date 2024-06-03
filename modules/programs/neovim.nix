{ config, pkgs, lib, ... }:
let
  cfg = config.programs.neovim;
in {
  programs.neovim = {
    package = pkgs.kiwiPackages.neovim;

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

  home.sessionVariables.EDITOR = lib.getExe cfg.finalPackage;
}
