{ lib, stdenv

, fetchFromGitHub

, pkg-config
, cmake
, extra-cmake-modules
, librsvg
, sphinx

, inotify-tools
, kdePackages
, libcloudproviders
, libsecret
, openssl
, pcre
, qt6Packages
, sqlite

, xdg-utils
}:
stdenv.mkDerivation rec {
  pname = "nextcloud-client";
  version = "3.15.2";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = "desktop";
    rev = "refs/tags/v${version}";
    hash = "sha256-JA6ke9tBS4IiuDWJ8Efa76+5os+RT0L/zv00ncgH+IU=";
  };

  patches = [
    # Explicitly move dbus configuration files to the store path rather than `/etc/dbus-1/services`.
    ./0001-Explicitly-copy-dbus-files-into-the-store-dir.patch
    ./0001-When-creating-the-autostart-entry-do-not-use-an-abso.patch
  ];

  postPatch = ''
    for file in src/libsync/vfs/*/CMakeLists.txt; do
      substituteInPlace $file \
        --replace-fail "PLUGINDIR" "KDE_INSTALL_PLUGINDIR"
    done
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    extra-cmake-modules
    librsvg
    sphinx
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = with qt6Packages; [
    inotify-tools
    kdePackages.kio
    libcloudproviders
    libsecret
    openssl
    pcre
    qt5compat
    qtbase
    qtkeychain
    qtsvg
    qttools
    qtwebengine
    qtwebsockets
    sqlite
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret ]}"
    # make xdg-open overrideable at runtime
    "--suffix PATH : ${lib.makeBinPath [ xdg-utils ]}"
  ];

  cmakeFlags = [
    "-DBUILD_UPDATER=OFF"
    "-DCMAKE_INSTALL_LIBDIR=lib" # expected to be prefix-relative by build code setting RPATH
    "-DMIRALL_VERSION_SUFFIX=" # remove git suffix from version
  ];

  postBuild = ''
    make doc-man
  '';

  meta = with lib; {
    changelog = "https://github.com/nextcloud/desktop/releases/tag/v${version}";
    description = "Desktop sync client for Nextcloud";
    homepage = "https://nextcloud.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kranzes SuperSandro2000 ];
    platforms = platforms.linux;
    mainProgram = "nextcloud";
  };
}
