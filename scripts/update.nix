{ pkgs
, homePackages
, ...
}:
let
  inherit (pkgs) lib;

  root = toString ../.;

  json = pkgs.formats.json { };
  toml = pkgs.formats.toml { };

  ignorePackages = [ "hub" "nix" ];
  packages = lib.filterAttrs (name: drv: let
    hasUrl = drv ? src && drv.src ? url;
    isIgnored = builtins.elem name ignorePackages;
  in hasUrl && !isIgnored) homePackages;

  entryConfigs = {
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

    github = builtins.match "https://github.com/([^/]+)/([^/]+)(/(.*))?" src.url;

    baseConfig = let
      githubOwner = builtins.elemAt github 0;
      githubRepo = lib.removeSuffix ".git" (builtins.elemAt github 1);
    in if github != null then {
      source = "github";
      github = "${githubOwner}/${githubRepo}";
      use_latest_release = true;
    } // lib.optionalAttrs (src ? rev && lib.hasPrefix "v" src.rev) {
      prefix = "v";
    }
    else null;
    config = if baseConfig != null
      then baseConfig
      // entryConfigs.${name}.config or { }
      // entryConfigs.${name}.overrides or { }
      else null;
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
