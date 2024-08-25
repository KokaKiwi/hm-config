{ lib

, fetchFromGitHub

, installShellFiles
, python3Packages
, go_1_22, buildGo122Module

, pkg-config

, bashInteractive
, dbus
, fish
, fontconfig
, harfbuzz
, imagemagick
, lcms2
, libGL
, libcanberra
, librsync
, libstartup_notification
, libunistring
, libxkbcommon
, ncurses
, nerdfonts
, openssl
, simde
, sudo
, wayland
, wayland-protocols
, xorg
, xxHash
, zsh
}:
let
  inherit (python3Packages) python;

  nerdfonts-kitty = nerdfonts.override {
    fonts = [
      "NerdFontsSymbolsOnly"
    ];
  };
in python3Packages.buildPythonApplication rec {
  pname = "kitty";
  version = "0.36.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "refs/tags/v${version}";
    hash = "sha256-7+MxxgQQlAje7klfJvvEWe8CfxyN0oTGQJ/QOORFUsY=";
  };

  goModules = (buildGo122Module {
    pname = "kitty-go-modules";
    inherit src version;
    vendorHash = "sha256-YN4sSdDNDIVgtcykg60H0bZEryRHJJfZ5rXWUMYXGr4=";
  }).goModules;

  buildInputs = [
    dbus
    fontconfig
    harfbuzz
    lcms2
    libGL
    libcanberra
    librsync
    libunistring
    libxkbcommon
    ncurses
    openssl.dev
    simde
    wayland
    wayland-protocols
    xxHash
  ] ++ (with xorg; [
    libX11
    libXrandr libXinerama libXcursor
    libXi libXext
  ]);

  nativeBuildInputs = [
    installShellFiles

    fontconfig.bin
    ncurses
    nerdfonts-kitty
    pkg-config
    go_1_22
  ] ++ (with python3Packages; [
    sphinx
    furo
    sphinx-copybutton
    sphinxext-opengraph
    sphinx-inline-tabs
  ]);

  outputs = [ "out" "terminfo" "shell_integration" "kitten" ];

  patches = [
    # Gets `test_ssh_env_vars` to pass when `bzip2` is in the output of `env`.
    ./fix-test_ssh_env_vars.patch
  ];

  hardeningDisable = [
    # causes redefinition of _FORTIFY_SOURCE
    "fortify3"
  ];

  CGO_ENABLED = 0;
  GOFLAGS = "-trimpath";

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
    export GOPROXY=off
    cp -r --reflink=auto $goModules vendor
  '';

  buildPhase = ''
    runHook preBuild

    ${python.pythonOnBuildForHost.interpreter} setup.py linux-package \
      --egl-library='${lib.getLib libGL}/lib/libEGL.so.1' \
      --startup-notification-library='${libstartup_notification}/lib/libstartup-notification-1.so' \
      --canberra-library='${libcanberra}/lib/libcanberra.so' \
      --fontconfig-library='${fontconfig.lib}/lib/libfontconfig.so' \
      --update-check-interval=0 \
      --shell-integration=enabled\ no-rc
    ${python.pythonOnBuildForHost.interpreter} setup.py build-launcher

    runHook postBuild
  '';

  nativeCheckInputs = [
    # Shells needed for shell integration tests
    bashInteractive
    zsh
    fish
    # integration tests need sudo
    sudo
  ] ++ (with python3Packages; [
    pillow
  ]);

  checkPhase = ''
      runHook preCheck

      # Fontconfig error: Cannot load default config file: No such file: (null)
      export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf

      # Required for `test_ssh_shell_integration` to pass.
      export TERM=kitty

      make test
      runHook postCheck
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    mkdir -p "$kitten/bin"
    cp -r linux-package/{bin,share,lib} "$out"
    cp linux-package/bin/kitten "$kitten/bin/kitten"

    # dereference the `kitty` symlink to make sure the actual executable
    # is wrapped on macOS as well (and not just the symlink)
    wrapProgram $(realpath "$out/bin/kitty") \
      --prefix PATH : "$out/bin:${lib.makeBinPath [ imagemagick ncurses.dev ]}"

    installShellCompletion --cmd kitty \
      --bash <("$out/bin/kitty" +complete setup bash) \
      --fish <("$out/bin/kitty" +complete setup fish2) \
      --zsh  <("$out/bin/kitty" +complete setup zsh)

    mkdir -p $terminfo/share
    mv $out/share/terminfo $terminfo/share/terminfo

    mkdir -p "$out/nix-support"
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    cp -r 'shell-integration' "$shell_integration"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/kovidgoyal/kitty";
    description = "A modern, hackable, featureful, OpenGL based terminal emulator";
    license = licenses.gpl3Only;
    changelog = [
      "https://sw.kovidgoyal.net/kitty/changelog/"
      "https://github.com/kovidgoyal/kitty/blob/v${version}/docs/changelog.rst"
    ];
    platforms = platforms.darwin ++ platforms.linux;
    mainProgram = "kitty";
    maintainers = with maintainers; [ tex rvolosatovs Luflosi kashw2 ];
  };
}
