{ ... }:
{
  systemd.user = {
    systemctlPath = "/usr/bin/systemctl";

    settings = {
      Manager.DefaultCPUAccounting = true;
    };
  };
}
