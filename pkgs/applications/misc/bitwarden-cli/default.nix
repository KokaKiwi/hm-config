{ lib

, fetchFromGitHub

, buildNpmPackage
, nodejs
, python3
}:
buildNpmPackage rec {
  pname = "bitwarden-cli";
  version = "2024.8.2";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-F/UbaNKkyf8AoTSa0B0Ipdr5Z8qAkbk7tJ0Cdq7gk+U=";
  };

  inherit nodejs;

  npmDepsHash = "sha256-SnrK26QaxHYKX0532rGBASjx9PwxKSsVFRzZ3Cs2GPk=";

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