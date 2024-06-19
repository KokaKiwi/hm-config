{ pkgs, ... }:
{
  programs.lan-mouse = {
    package = pkgs.lan-mouse.override {
      features = [ "wayland" "xdg_desktop_portal" ];
    };

    systemd = true;

    settings = {
      port = 4242;
    };
  };
}
