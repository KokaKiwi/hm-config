{ pkgs, ... }:
{
  imports = [
    ./modules/all-modules.nix
  ];

  home.stateVersion = "24.05";

  home.username = "kokakiwi";
  home.homeDirectory = "/home/kokakiwi";

  home.preferXdgDirectories = true;

  xdg.enable = true;
  programs.man.enable = false;
  xdg.mime.enable = false;

  nix.gc.automatic = true;

  news.display = "silent";

  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = false;
    locales = [
      "fr_FR.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
    ];
  };
}
