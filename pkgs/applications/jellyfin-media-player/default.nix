{ lib
, fetchFromGitHub
, mkDerivation
, stdenv
, SDL2
, cmake
, libGL
, libX11
, libXrandr
, libvdpau
, mpv
, ninja
, pkg-config
, python3
, qtbase
, qtwayland
, qtwebchannel
, qtwebengine
, qtx11extras
, jellyfin-web
, withDbus ? stdenv.isLinux, dbus
}:

mkDerivation rec {
  pname = "jellyfin-media-player";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-media-player";
    rev = "v${version}";
    sha256 = "sha256-XeDyNSQpnTgV6u1vT69DEfbFHvBu1LNhvsQmKvUYq2o=";
  };

  patches = [
    ./0001-fix-the-location-of-the-jellyfin-web-path.patch
    ./0002-disable-update-notifications.patch
  ];

  buildInputs = [
    SDL2
    libGL
    libX11
    libXrandr
    libvdpau
    mpv
    qtbase
    qtwebchannel
    qtwebengine
    qtx11extras
  ] ++ lib.optionals stdenv.isLinux [
    qtwayland
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
  ];

  cmakeFlags = [
    "-G" "Ninja"
    "-D" "QTROOT=${qtbase}"
  ] ++ lib.optionals (!withDbus) [
    "-D" "LINUX_X11POWER=ON"
  ];

  preConfigure = ''
    # link the jellyfin-web files to be copied by cmake (see fix-web-path.patch)
    ln -s ${jellyfin-web}/share/jellyfin-web .
  '';

  meta = with lib; {
    homepage = "https://github.com/jellyfin/jellyfin-media-player";
    description = "Jellyfin Desktop Client based on Plex Media Player";
    license = with licenses; [ gpl2Only mit ];
    platforms = [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" ];
    mainProgram = "jellyfinmediaplayer";
  };
}
