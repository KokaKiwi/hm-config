{ pkgs, lib, ... }:
with lib;
let
  git = let
    git = pkgs.git.overrideAttrs (self: prev: {
      version = "2.47.1";

      src = pkgs.fetchurl {
        url = "https://www.kernel.org/pub/software/scm/git/git-${self.version}.tar.xz";
        hash = "sha256-89j5uyOuOSN06RzZ05WXDavFucXucvOYhGE82Epu0xA=";
      };

      env.NIX_CFLAGS_LINK = toString (prev.NIX_CFLAGS_LINK or "") + " -fuse-ld=lld";
    });
  in git.override {
    stdenv = pkgs.llvmStdenv;

    python3 = pkgs.python312;
    openssl = pkgs.openssl_3_3;
    curl = pkgs.curl.override {
      openssl = pkgs.quictls;

      http3Support = true;
    };

    perlSupport = true;
    pythonSupport = true;

    svnSupport = true;
    sendEmailSupport = true;

    withSsh = true;
    withLibsecret = true;
  };

  signingDirectories = [
    "~/projects/contrib/tor/"
    "~/projects/nix/"
    "~/projects/pro/edgee/"
    "~/projects/langs/rust/hex/.git"
  ];
in {
  imports = [
    ./git/git-cliff.nix
  ];

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

    pathConfigs = lib.listToAttrs (map (path: lib.nameValuePair path {
      commit.gpgSign = true;
      tag.gpgSign = true;
    }) signingDirectories);
  };

  home.packages = with pkgs; [
    commitizen commitlint
  ];
}
