{}:
{
  gitVersion = version: rev:
    "${version}-g${builtins.substring 0 8 rev}";
}
