{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;

    package = pkgs.nushell.override {
      python3 = pkgs.python312;
      inherit (pkgs.rustTools.rust_1_81) rustPlatform;
      inherit (pkgs.kiwiPackages) libgit2;

      additionalFeatures = p: [
        "system-clipboard"
      ];
    };
  };
}
