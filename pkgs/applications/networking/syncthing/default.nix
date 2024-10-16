{ lib, stdenv
, pkgsBuildBuild

, fetchFromGitHub

, buildGoModule

, go
}:
buildGoModule rec {
  pname = "syncthing";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "syncthing";
    repo = "syncthing";
    rev = "v${version}";
    hash = "sha256-JW78n/3hssH600uXn4YLxcIJylPbSpEZICtKmqfqamI=";
  };

  vendorHash = "sha256-9/PfiOSCInduQXZ47KbrD3ca9O0Zt+TP7XoX+HjwQgs=";

  doCheck = false;

  BUILD_USER = "nix";
  BUILD_HOST = "nix";

  buildPhase = ''
    runHook preBuild
    (
      export GOOS="${pkgsBuildBuild.go.GOOS}" GOARCH="${pkgsBuildBuild.go.GOARCH}" CC=$CC_FOR_BUILD
      go build build.go
      go generate github.com/syncthing/syncthing/lib/api/auto github.com/syncthing/syncthing/cmd/strelaypoolsrv/auto
    )
    ./build -goos ${go.GOOS} -goarch ${go.GOARCH} -no-upgrade -version v${version} build syncthing
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 syncthing $out/bin/syncthing
    runHook postInstall
  '';

  postInstall = ''
    # This installs man pages in the correct directory according to the suffix
    # on the filename
    for mf in man/*.[1-9]; do
      mantype="$(echo "$mf" | awk -F"." '{print $NF}')"
      mandir="$out/share/man/man$mantype"
      install -Dm644 "$mf" "$mandir/$(basename "$mf")"
    done

  '' + lib.optionalString (stdenv.isLinux) ''
    mkdir -p $out/lib/systemd/{system,user}

    substitute etc/linux-systemd/system/syncthing@.service \
               $out/lib/systemd/system/syncthing@.service \
               --replace /usr/bin/syncthing $out/bin/syncthing

    substitute etc/linux-systemd/user/syncthing.service \
               $out/lib/systemd/user/syncthing.service \
               --replace /usr/bin/syncthing $out/bin/syncthing
  '';

  meta = with lib; {
    homepage = "https://syncthing.net/";
    description = "Open Source Continuous File Synchronization";
    changelog = "https://github.com/syncthing/syncthing/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ joko peterhoeg ];
    mainProgram = target;
    platforms = platforms.unix;
  };
}
