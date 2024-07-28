{ config, pkgs, ... }:
let
  mpdCfg = config.services.mpd;

  inherit (config) xdg;
in {
  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override {
      stdenv = pkgs.llvmStdenv;
      visualizerSupport = true;
    };

    settings = {
      mpd_host = "127.0.0.1";
      mpd_port = mpdCfg.network.port;
      mpd_music_dir = xdg.userDirs.music;

      media_library_primary_tag = "album_artist";

      user_interface = "alternative";
    };
  };

  services.mopidy = {
    enable = true;

    extensionPackages = with pkgs; [
      mopidy-local
      mopidy-mpd
    ];

    settings = {
      core = {
        restore_state = true;
      };

      file = {
        enabled = true;
        media_dirs = [
          "$XDG_MUSIC_DIR|${xdg.userDirs.music}"
        ];
        follow_symlinks = true;
        excluded_file_extensions = [
          ".directory"
          ".html"
          ".jpeg"
          ".jpg"
          ".log"
          ".nfo"
          ".pdf"
          ".png"
          ".txt"
          ".zip"
        ];
      };

      local = {
        enabled = true;
        media_dir = xdg.userDirs.music;
      };

      mpd = {
        enabled = true;
        port = mpdCfg.network.port;
      };
    };
  };

  programs.beets = {
    enable = true;

    settings = {
      asciify_paths = true;

      import = {
        resume = true;
        languages = "en jp";
        group_albums = true;
      };

      convert = {
        copy_album_art = true;
        dest = "${xdg.userDirs.music}";
        embed = false;
        format = "ogg";
      };

      ui = {
        terminal_width = 120;
      };

      plugins = [
        "chroma"
        "convert"
        "fetchart"
        "fromfilename"
        "info"
        "ipfs"
        "lastgenre"
        "mbsync"
        "thumbnails"
      ];
    };

    mpdIntegration = {
      enableStats = true;
      enableUpdate = true;

      host = "127.0.0.1";
      port = mpdCfg.network.port;
    };
  };
}
