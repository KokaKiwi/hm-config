{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.neovim;

  neovimUtils = pkgs.neovimUtils.override {
    python3Packages = cfg.python3Package.pkgs;
  };
  neovimConfig = neovimUtils.makeNeovimConfig ({
    inherit (cfg) viAlias vimAlias;

    wrapRc = false;
  } // cfg.extraNeovimConfigArgs);
in {
  disabledModules = [
    "programs/neovim.nix"
    # Defines programs.neovim.modules
    "programs/pywal.nix"
  ];

  options.programs.neovim = {
    enable = mkEnableOption "neovim";

    package = mkPackageOption pkgs "neovim-unwrapped" { };

    finalPackage = mkOption {
      type = types.package;
      readOnly = true;
    };

    viAlias = mkOption {
      type = types.bool;
      default = false;
    };
    vimAlias = mkOption {
      type = types.bool;
      default = false;
    };
    vimdiffAlias = mkOption {
      type = types.bool;
      default = false;
    };

    python3Package = mkPackageOption pkgs "python3" { };

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
    };

    extraNeovimConfigArgs = mkOption {
      type = types.attrs;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    programs.neovim.finalPackage = pkgs.wrapNeovimUnstable cfg.package neovimConfig;

    home.packages = [ cfg.finalPackage ];

    home.sessionVariables = mkIf cfg.defaultEditor {
      EDITOR = "nvim";
    };

    programs.bash.shellAliases = mkIf cfg.vimdiffAlias {
      vimdiff = "nvim -d";
    };
    programs.fish.shellAliases = mkIf cfg.vimdiffAlias {
      vimdiff = "nvim -d";
    };
    programs.zsh.shellAliases = mkIf cfg.vimdiffAlias {
      vimdiff = "nvim -d";
    };
  };
}
