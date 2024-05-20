{ pkgs, ... }:
{
  programs.neovim = {
    package = pkgs.kiwiPackages.neovim;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    python3Package = pkgs.python312;
    rubyPackage = pkgs.ruby_3_3;
  };
}
