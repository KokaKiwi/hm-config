{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = let
      vscode = pkgs.kiwiPackages.vscodium;
    in config.lib.opengl.wrapPackage vscode { };

    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      rust-lang.rust-analyzer
    ];

    userSettings = {
      "files.autoSave" = "off";
      "[nix]"."editor.tabSize" = 2;

      "workbench.colorTheme" = "Catppuccin Mocha";
      "catppuccin.accentColor" = "green";
    }
    ;
  };
}
