{ lib

, fetchFromGitHub

, buildGoModule
}:
buildGoModule rec {
  pname = "act";
  version = "0.2.67";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yNa6o35YUP8D8K3kQLHQOG3V9mWGoxNvYgw5UQOqAtc=";
  };

  vendorHash = "sha256-bkOLortxztmzAO/KCbQC4YsZ5iAero1yxblCkDZg8Ds=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kashw2 ];
  };
}
