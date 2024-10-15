{ pkgs, ... }:
{
  services.activate-linux = {
    enable = true;
    package = pkgs.activate-linux.override {
      backends = [ "wayland" ];
    };

    config = {
      text-title = "Activate Nix/Arch::OS";
      text-message = "8098 is a good bot";

      scale = 1.3;
    };
  };
}
