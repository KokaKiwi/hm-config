{ lib

, fetchFromGitHub

, buildGoModule
}:
buildGoModule rec {
  pname = "minio-client";
  version = "2024-11-21T17-21-54Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "sha256-z6ixa5nrKcrvaBC1V6/iXCeHFO4xOkFf/yJ8HLQQcaY=";
  };

  vendorHash = "sha256-teG+GrzmUgJ6QhcxDSbWXP32hRuCgoCvH2BoNL8ddUc=";

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
