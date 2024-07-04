{ config, pkgs, ... }:
{
  programs.aura = {
    package = pkgs.nur.repos.kokakiwi.aura;

    settings = {
      general = {
        editor = "${config.programs.neovim.finalPackage}/bin/nvim";
        language = "en-GB";
      };
    };
  };
}
