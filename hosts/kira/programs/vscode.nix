{ config, pkgs, lib, sources, ... }:
{
  programs.vscode = {
    enable = true;
    package = let
      vscode = pkgs.callPackage "${sources.nixpkgs}/pkgs/applications/editors/vscode/generic.nix" rec {
        pname = "vscodium";
        version = "1.93.1.24256";

        src = pkgs.fetchurl {
          url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-linux-x64-${version}.tar.gz";
          sha256 = "sha256-rtn7mGa3qQjC0atA4IDrFs9OtMb1NIiovnCuf2iJ+JI=";
        };

        sourceRoot = ".";
        commandLineArgs = "";
        useVSCodeRipgrep = false;

        executableName = "codium";
        longName = "VSCodium";
        shortName = "vscodium";

        updateScript = null;

        meta = with lib; {
          description = ''
            Open source source code editor developed by Microsoft for Windows,
            Linux and macOS (VS Code without MS branding/telemetry/licensing)
          '';
          longDescription = ''
            Open source source code editor developed by Microsoft for Windows,
            Linux and macOS. It includes support for debugging, embedded Git
            control, syntax highlighting, intelligent code completion, snippets,
            and code refactoring. It is also customizable, so users can change the
            editor's theme, keyboard shortcuts, and preferences
          '';
          homepage = "https://github.com/VSCodium/vscodium";
          downloadPage = "https://github.com/VSCodium/vscodium/releases";
          license = licenses.mit;
          sourceProvenance = with sourceTypes; [ binaryNativeCode ];
          maintainers = with maintainers; [ synthetica bobby285271 ludovicopiero ];
          mainProgram = "codium";
          platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" "armv7l-linux" ];
        };
      };
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
