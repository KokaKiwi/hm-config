{ lib, stdenv

, fetchFromGitHub

, pkg-config
, autoconf
, automake
, libtool

, boost
, libmpdclient
, ncurses
, readline
, libiconv
, icu
, curl

, outputsSupport ? true # outputs screen
, visualizerSupport ? false, fftw # visualizer screen
, clockSupport ? true # clock screen
, taglibSupport ? true, taglib # tag editor
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ncmpcpp";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "ncmpcpp";
    repo = "ncmpcpp";
    rev = finalAttrs.version;
    hash = "sha256-HRJQ+IOQ8xP1QkPlLI+VtDUWaI2m0Aw0fCDWHhgsOLY=";
  };

  enableParallelBuilding = true;

  strictDeps = true;

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "BOOST_LIB_SUFFIX=" ]
    ++ lib.optional outputsSupport "--enable-outputs"
    ++ lib.optional visualizerSupport "--enable-visualizer --with-fftw"
    ++ lib.optional clockSupport "--enable-clock"
    ++ lib.optional taglibSupport "--with-taglib";

  nativeBuildInputs = [ pkg-config autoconf automake libtool ]
    ++ lib.optional taglibSupport taglib;

  buildInputs = [ boost libmpdclient ncurses readline libiconv icu curl ]
    ++ lib.optional visualizerSupport fftw
    ++ lib.optional taglibSupport taglib;

  meta = with lib; {
    description = "Featureful ncurses based MPD client inspired by ncmpc";
    homepage    = "https://rybczak.net/ncmpcpp/";
    changelog   = "https://github.com/ncmpcpp/ncmpcpp/blob/${finalAttrs.version}/CHANGELOG.md";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ koral lovek323 ];
    platforms   = platforms.all;
    mainProgram = "ncmpcpp";
  };
})
