{ config, pkgs, lib, ... }:
let
  cfg = config.services.syncthing;
in {
  services.syncthing = {
    enable = true;

    tray = {
      enable = true;
      package = pkgs.syncthingtray.override {
        webviewSupport = false;
        jsSupport = false;
        plasmoidSupport = false;
      };
    };
  };

  systemd.user.services.${cfg.tray.package.pname} = {
    Unit.Requires = lib.mkForce [ ];
  };
}
