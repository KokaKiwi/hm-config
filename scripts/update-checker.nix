{ pkgs
, homePackages
, doWarn ? true
, ...
}:
let
  inherit (pkgs) lib;

  ignoredPackages = [
    # Let's nixpkgs update these one
    "nix"
    # Too old
    "hub"
    # My own packages
    "cargo-shell" "mux" "xinspect"
  ];
  extraPackages = [ ];

  configs = {
    aria2.prefix = "release-";
    cargo-nextest.prefix = "cargo-nextest-";
    cargo-nextest.include_regex = "cargo-nextest-.*";
    gleam.prefix = "v";
    kitty.prefix = "v";
    kubo.prefix = "v";
    obsidian.prefix = "v";
    zoxide.prefix = "v";
  };
  sources = {
    glab = {
      source = "gitlab";
      gitlab = "gitlab-org/cli";
      use_max_tag = true;
    };
    cargo-depgraph = {
      source = "github";
      github = "jplatte/cargo-depgraph";
      use_max_tag = true;
    };
    git-with-svn = {
      source = "archpkg";
      archpkg = "git";
      strip_release = true;
    };
    gnupg = {
      source = "archpkg";
      archpkg = "gnupg";
      strip_release = true;
    };
    ncmpcpp = {
      source = "archpkg";
      archpkg = "ncmpcpp";
      strip_release = true;
    };
    nix-output-monitor = {
      source = "gitea";
      host = "code.maralorn.de";
      gitea = "maralorn/nix-output-monitor";
      use_max_tag = true;
      prefix = "v";
    };
  };
  overrides = {
    pgcli.use_latest_tag = true;
  };

  aliases = {
    neovim = pkgs.kiwiPackages.neovim;
  };

  packages = let
    extraPackages' = let
      namedPackages = lib.filter (drv: drv ? pname) extraPackages;
    in builtins.listToAttrs (map (drv: lib.nameValuePair drv.pname drv) namedPackages);
    allPackages = homePackages // extraPackages';

    resolvedPackages = lib.mapAttrs (name: drv:
      if aliases ? ${name} then aliases.${name} else drv
    ) allPackages;
  in lib.filterAttrs (name: drv: let
    isIgnored = builtins.elem name ignoredPackages;
  in !isIgnored) resolvedPackages;
in pkgs.nur.repos.kokakiwi.lib.mkUpdateChecker {
  inherit packages;
  inherit configs sources overrides;
  inherit doWarn;

  nvcheckerConfig = {
    keyfile = "~/.config/nvchecker/keyfile.toml";
  };
}
