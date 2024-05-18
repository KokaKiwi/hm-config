{ pkgs
, homePackages
, doWarn ? true
, ...
}:
let
  inherit (pkgs) lib;

  json = pkgs.formats.json { };
  toml = pkgs.formats.toml { };

  ignorePackages = [
    # Let's nixpkgs update these one
    "nix"
    # Too old
    "hub"
    # My own packages
    "cargo-shell" "mux"
  ];
  packages = lib.filterAttrs (name: drv: let
    hasUrl = drv ? src && drv.src ? url;
    isIgnored = builtins.elem name ignorePackages;
  in hasUrl && !isIgnored) homePackages;

  entryConfigs = {
    glab.source = {
      source = "gitlab";
      gitlab = "gitlab-org/cli";
      use_max_tag = true;
    };
    git-with-svn.source = {
      source = "archpkg";
      archpkg = "git";
      strip_release = true;
    };
    gnupg.source = {
      source = "archpkg";
      archpkg = "gnupg";
      strip_release = true;
    };
    ncmpcpp.source = {
      source = "archpkg";
      archpkg = "ncmpcpp";
      strip_release = true;
    };
    nix-output-monitor.source = {
      source = "gitea";
      host = "code.maralorn.de";
      gitea = "maralorn/nix-output-monitor";
      use_max_tag = true;
      prefix = "v";
    };

    aria2.config.prefix = "release-";
    gleam.config.prefix = "v";
    kitty.config.prefix = "v";
    kubo.config.prefix = "v";
    obsidian.config.prefix = "v";
    zoxide.config.prefix = "v";

    pgcli.overrides.use_latest_tag = true;
  };

  oldVer = {
    version = 2;
    data = lib.mapAttrs (name: drv: {
      version = drv.version;
    }) packages;
  };
  oldVerFile = json.generate "oldver.json" oldVer;

  mkEntry = name: drv: let
    inherit (drv) src;

    github = builtins.match "https://github.com/([^/]+)/([^/]+)(/.*)?" src.url;
    pypi = builtins.match "mirror://pypi/./([^/]+)/.*" src.url;
    cratesio = builtins.match "https://crates.io/api/v1/crates/([^/]+)/.*" src.url;

    unknownUrl = lib.traceIf doWarn "WARNING: Unrecognized URL: ${src.url}" null;

    baseConfig = let
      githubOwner = builtins.elemAt github 0;
      githubRepo = lib.removeSuffix ".git" (builtins.elemAt github 1);

      pypiName = builtins.elemAt pypi 0;

      cratesioName = builtins.elemAt cratesio 0;
    in if entryConfigs ? ${name}.source then entryConfigs.${name}.source
    else if github != null then {
      source = "github";
      github = "${githubOwner}/${githubRepo}";
      use_latest_release = true;
    }
    else if pypi != null then {
      source = "pypi";
      pypi = pypiName;
    }
    else if cratesio != null then {
      source = "cratesio";
      cratesio = cratesioName;
    }
    else null;
    config = if baseConfig != null
      then baseConfig
      // lib.optionalAttrs (src ? rev && lib.hasPrefix "v" src.rev) {
        prefix = "v";
      }
      // entryConfigs.${name}.config or { }
      // entryConfigs.${name}.overrides or { }
      else unknownUrl;
  in if config == null then null else {
    ${name} = config;
  };
  entries = lib.pipe packages [
    (lib.mapAttrsToList mkEntry)
    (lib.filter (e: e != null))
    lib.mergeAttrsList
  ];

  config = {
    __config__ = {
      keyfile = "~/.config/nvchecker/keyfile.toml";
      oldver = toString oldVerFile;
      newver = "/tmp/newver.json";
    };
  } // entries;
  configFile = toml.generate "nvchecker.toml" config;
in {
  checkUpdates = ''
    ${pkgs.nvchecker}/bin/nvchecker --file ${configFile}
  '';
}
