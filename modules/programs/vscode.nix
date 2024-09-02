{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = config.lib.opengl.wrapPackage pkgs.vscodium;

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
