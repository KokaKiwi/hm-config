{ pkgs, lib, ... }:
with lib;
let
  git = let
    git = pkgs.git.overrideAttrs (prev: rec {
      version = "2.45.2";

      src = pkgs.fetchurl {
        url = "https://mirrors.edge.kernel.org/pub/software/scm/git/git-${version}.tar.xz";
        hash = "sha256-Ub/ofrHAL+0UhAUYdTZe6rIpgx0w0M7F2JoU+eQOmts=";
      };

      env.NIX_CFLAGS_LINK = toString (prev.NIX_CFLAGS_LINK or "") + " -fuse-ld=lld";
    });
  in git.override {
    stdenv = pkgs.llvmStdenv;

    python3 = pkgs.python312;

    svnSupport = true;
    sendEmailSupport = true;
    withSsh = true;
    withLibsecret = true;
  };
in {
  programs.git = {
    enable = true;
    package = git;

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
