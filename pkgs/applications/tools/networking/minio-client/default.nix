{ lib

, fetchFromGitHub

, buildGoModule
}:
buildGoModule rec {
  pname = "minio-client";
  version = "2024-09-16T17-43-14Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "sha256-j9NEeTUP/pkEhywhNasQQzTwUBcUwq+KVEGGB1hzVw0=";
  };

  vendorHash = "sha256-KNnYxE3kt/eemnhsRf29SZX0Q+ECzdMFVgcmd7uCsyY=";

  subPackages = [ "." ];

  patchPhase = ''
    sed -i "s/Version.*/Version = \"${version}\"/g" cmd/build-constants.go
    sed -i "s/ReleaseTag.*/ReleaseTag = \"RELEASE.${version}\"/g" cmd/build-constants.go
    sed -i "s/CommitID.*/CommitID = \"${src.rev}\"/g" cmd/build-constants.go
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/mc --version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/minio/mc";
    description = "A replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
    maintainers = with maintainers; [ bachp eelco ];
    mainProgram = "mc";
    license = licenses.asl20;
  };
}
