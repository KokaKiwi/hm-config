{ pkgs, lib
, config, homePackages
, doWarn ? true
, ...
}:
let
  ignoredPackages = [
    # Let's nixpkgs handle these
    "nixfmt"
    # Too old
    "hub"
    # My own packages
    "cargo-shell" "mux" "xinspect"
    "doll"
    # Unstable packages
    "glances"
    # Haskell stuff
    "ShellCheck"
  ];

  neovim = config.programs.neovim.package;

  extraPackages = [
    neovim.tree-sitter neovim.lua
    config.home.shell.package
    pkgs.git-interactive-rebase-tool
    pkgs.nix-your-shell
  ];
  aliases = let
    mkUnstable = drv: drv.overrideAttrs (super: {
      name = "${drv.name}-unstable";
      version = super.src.rev;
    });
  in {
    inherit neovim;
    luajit = mkUnstable neovim.lua;
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
  inherit doWarn;
  inherit packages;

  configs = {
    aria2.prefix = "release-";
    bitwarden-cli.include_regex = "cli-v.*";
    bitwarden-cli.prefix = "cli-v";
    bun.include_regex = "bun-v.*";
    bun.prefix = "bun-v";
    cargo-nextest.include_regex = "cargo-nextest-.*";
    cargo-nextest.prefix = "cargo-nextest-";
    gleam.prefix = "v";
    imhex.prefix = "v";
    kitty.prefix = "v";
    kubo.prefix = "v";
    minio-client.prefix = "RELEASE.";
    obsidian.prefix = "v";
    patool.prefix = "upstream/";
    stockfish.include_regex = "sf_.*";
    stockfish.prefix = "sf_";
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
    kx-aspe-cli = {
      source = "git";
      git = "https://codeberg.org/keyoxide/kx-aspe-cli.git";
      use_commit = true;
    };
    ncmpcpp = {
      source = "archpkg";
      archpkg = "ncmpcpp";
      strip_release = true;
    };
    lix = {
      source = "gitea";
      host = "git.lix.systems";
      gitea = "lix-project/lix";
      use_max_tag = true;
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
    aura.exclude_regex = "^$";
    lix.exclude_regex = "^$";
    pgcli.use_latest_tag = true;
  };

  nvcheckerConfig = {
    keyfile = "~/.config/nvchecker/keyfile.toml";
  };
}
