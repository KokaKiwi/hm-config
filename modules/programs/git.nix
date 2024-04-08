{ pkgs, lib, ... }:
with lib;
{
  programs.git = {
    userName = "KokaKiwi";
    userEmail = "kokakiwi+git@kokakiwi.net";

    aliases = {
      cp = "cherry-pick";

      rev-short = "rev-list -1 --oneline";

      ui = "!gitui";
    };

    signing = {
      key = "BECD152B6BAA1FA0FB5E00EF42C5CC9D07DF3288";
      signByDefault = true;
    };

    lfs.enable = true;

    delta = {
      enable = true;
      catppuccin.enable = true;
      options = {
        light = false;
        line-numbers = true;
        navigate = true;
      };
    };

    extraConfig = {
      core = {
        autocrlf = "input";
        editor = "/usr/bin/nvim";
      };

      am.threeWay = true;
      color.ui = "auto";
      fetch.parallel = 4;
      gui.commitMsgWidth = 120;
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      pull.rebase = true;
      rebase.autoStash = true;
      sequence.editor = getExe pkgs.git-interactive-rebase-tool;

      lfs."https://gitlab.kokakiwi.net".locksverify = true;
    };
  };
}
