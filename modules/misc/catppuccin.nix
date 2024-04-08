{ ... }:
let
  sources = import ../../nix;
in {
  imports = [
    "${sources.catppuccin}/modules/home-manager"
  ];

  catppuccin = {
    flavour = "mocha";
    accent = "green";
  };
}
