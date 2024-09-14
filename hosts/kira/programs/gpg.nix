{ ... }:
{
  programs.gpg = {
    enable = true;
    settings = {
      keyserver = "keyserver.ubuntu.com";
    };
  };
}
