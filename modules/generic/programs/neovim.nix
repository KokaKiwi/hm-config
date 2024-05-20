{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.neovim;

  neovimUtils = pkgs.neovimUtils.override {
    python3Packages = cfg.python3Package.pkgs;

    neovim-unwrapped = cfg.package;
  };
  neovimConfig = let
    base = neovimUtils.makeNeovimConfig ({
      inherit (cfg)
        viAlias vimAlias
        withPython3 withNodeJs withRuby withPerl
        extraPython3Packages extraLuaPackages;

      wrapRc = false;
    } // cfg.extraNeovimConfigArgs);
  in base // {
    wrapperArgs =
      base.wrapperArgs
      ++ cfg.extraWrapperArgs
      ++ optionals (cfg.extraPackages != [ ]) [
        "--suffix" "PATH" ":"
        (makeBinPath cfg.extraPackages)
      ];
  };
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

    withPython3 = mkOption {
      type = types.bool;
      default = true;
    };
    withNodeJs = mkOption {
      type = types.bool;
      default = false;
    };
    withRuby = mkOption {
      type = types.bool;
      default = true;
    };
    withPerl = mkOption {
      type = types.bool;
      default = false;
    };

    python3Package = mkPackageOption pkgs "python3" { };

    extraLuaPackages = mkOption {
      type = with types; functionTo (listOf package);
      default = _: [ ];
      defaultText = literalExpression "ps: [ ]";
    };
    extraPython3Packages = mkOption {
      type = with types; functionTo (listOf package);
      default = _: [ ];
      defaultText = literalExpression "ps: [ ]";
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
    };

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
    };

    extraNeovimConfigArgs = mkOption {
      type = types.attrs;
      default = { };
    };

    extraWrapperArgs = mkOption {
      type = with types; listOf str;
      default = [ ];
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
