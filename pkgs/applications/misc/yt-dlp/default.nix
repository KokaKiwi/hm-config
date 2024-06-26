{ lib

, fetchPypi
, fetchFromGitHub

, buildPythonPackage

, ffmpeg
, rtmpdump

, hatchling

, atomicparsley
, brotli
, certifi
, mutagen
, pycryptodomex
, requests
, secretstorage
, urllib3
, websockets

, atomicparsleySupport ? true
, ffmpegSupport ? true
, rtmpSupport ? true
, withAlias ? false # Provides bin/youtube-dl for backcompat
}:
buildPythonPackage rec {
  pname = "yt-dlp";
  version = "2024.05.27-unstable-2024-06-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yt-dlp";
    repo = "yt-dlp";
    rev = "61edf57f8f13f6dfd81154174e647eb5fdd26089";
    hash = "sha256-tx4zVVBUeFzkCHxI1XPf2T2QEvP4RfNR8E846QR3ngo=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    brotli
    certifi
    mutagen
    pycryptodomex
    requests
    secretstorage  # "optional", as in not in requirements.txt, needed for `--cookies-from-browser`
    urllib3
    websockets
  ];

  # Ensure these utilities are available in $PATH:
  # - ffmpeg: post-processing & transcoding support
  # - rtmpdump: download files over RTMP
  # - atomicparsley: embedding thumbnails
  makeWrapperArgs =
    let
      packagesToBinPath = []
        ++ lib.optional atomicparsleySupport atomicparsley
        ++ lib.optional ffmpegSupport ffmpeg
        ++ lib.optional rtmpSupport rtmpdump;
    in lib.optionals (packagesToBinPath != [])
    [ ''--prefix PATH : "${lib.makeBinPath packagesToBinPath}"'' ];

  setupPyBuildFlags = [
    "build_lazy_extractors"
  ];

  # Requires network
  doCheck = false;

  postInstall = lib.optionalString withAlias ''
    ln -s "$out/bin/yt-dlp" "$out/bin/youtube-dl"
  '';

  meta = with lib; {
    homepage = "https://github.com/yt-dlp/yt-dlp/";
    description = "Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)";
    longDescription = ''
      yt-dlp is a youtube-dl fork based on the now inactive youtube-dlc.

      youtube-dl is a small, Python-based command-line program
      to download videos from YouTube.com and a few more sites.
      youtube-dl is released to the public domain, which means
      you can modify it, redistribute it or use it however you like.
    '';
    changelog = "https://github.com/yt-dlp/yt-dlp/releases/tag/${version}";
    license = licenses.unlicense;
    maintainers = with maintainers; [ mkg20001 SuperSandro2000 ];
    mainProgram = "yt-dlp";
  };
}
