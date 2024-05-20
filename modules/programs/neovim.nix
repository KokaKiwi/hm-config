{ pkgs, ... }:
let
  python = pkgs.python312;
  neovimUtils = pkgs.neovimUtils.override {
    python3Packages = python.pkgs;
  };
  neovimConfig = neovimUtils.makeNeovimConfig {
    viAlias = true;
    vimAlias = true;

    wrapRc = false;
  };

  neovim = pkgs.wrapNeovimUnstable pkgs.kiwiPackages.neovim (neovimConfig // {
    wrapperArgs = neovimConfig.wrapperArgs;
  });
in {
  home.packages = [ neovim ];
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.fish.shellAliases = {
    vimdiff = "nvim -d";
  };
}
