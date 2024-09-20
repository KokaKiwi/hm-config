{ lib

, fetchFromGitHub

, buildNpmPackage
, nodejs
, python3
}:
buildNpmPackage rec {
  pname = "bitwarden-cli";
  version = "2024.9.0";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-o5nRG2j73qheDOyeFfSga64D8HbTn1EUrCiN0W+Xn0w=";
  };

  inherit nodejs;

  npmDepsHash = "sha256-L7/frKCNlq0xr6T+aSqyEQ44yrIXwcpdU/djrhCJNNk=";

  nativeBuildInputs = [
    python3
  ];

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmBuildScript = "build:oss:prod";

  npmWorkspace = "apps/cli";

  npmFlags = [ "--legacy-peer-deps" ];

  meta = with lib; {
    changelog = "https://github.com/bitwarden/clients/releases/tag/${src.rev}";
    description = "A secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3Only;
    mainProgram = "bw";
    maintainers = with maintainers; [ dotlambda ];
  };
}
