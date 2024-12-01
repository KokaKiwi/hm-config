{ lib

, fetchFromGitHub

, buildGoModule
}:
buildGoModule rec {
  pname = "act";
  version = "0.2.70";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-7e2ehUM3d5hcFtaahW/hrhVkpy74ufMdYwdnbsUA+WM=";
  };

  vendorHash = "sha256-2fHNiquFg6I0JefqXfXRrnXxKPkNQOtQB7fznldO3GE=";

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
