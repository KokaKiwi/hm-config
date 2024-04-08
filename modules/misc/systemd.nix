{ ... }:
{
  systemd.user = {
    systemctlPath = "/usr/bin/systemctl";
    startServices = "sd-switch";

    settings = {
      Manager.DefaultCPUAccounting = true;
    };
  };
}
