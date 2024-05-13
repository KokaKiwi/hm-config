{ sources, ... }:
{
  imports = [
    "${sources.catppuccin}/modules/home-manager"
  ];

  catppuccin = {
    enable = true;
    flavour = "mocha";
    accent = "green";
  };
}
