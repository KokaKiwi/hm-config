{ lib

, fetchFromGitHub

, buildGoModule
}:
buildGoModule rec {
  pname = "minio-client";
  version = "2024-07-03T20-17-25Z";

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
    sha256 = "sha256-EElcLPbz4IXr/OTjSVXz3wQc/OuLBGzplc4W7P7tStg=";
  };

  vendorHash = "sha256-8F3NSPCT0pdyOaBPXt94m1TiLMUHeLje83fxmc0RJzs=";

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
