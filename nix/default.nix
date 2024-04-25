let
  system = builtins.currentSystem;

  patches = {
    catppuccin = [
      ./patches/catppuccin/0001-Expose-sources-and-lib.ctp.patch
      ./patches/catppuccin/0002-feat-tmux-add-support-for-extraConfig.patch
    ];
  };

  main = import ./sources.nix;

  pkgs = import main.nixpkgs { inherit system; };
  importSource = sourcesFile: import ./sources.nix {
    inherit sourcesFile system pkgs;
  };

  applyPatches = sources: let
    inherit (pkgs) lib;
  in lib.mapAttrs (name: source: let
    sourcePatches = patches.${name} or [ ];
  in if sourcePatches == [ ] then source
  else pkgs.srcOnly {
    inherit name;
    src = source;
    patches = sourcePatches;
  }
  ) sources;

  nur = importSource ./sources-nur.json;
in applyPatches (main // nur)
