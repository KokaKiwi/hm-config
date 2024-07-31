{ lib

, fetchFromGitHub

, buildNpmPackage
, nodejs
, python3
}:
buildNpmPackage rec {
  pname = "bitwarden-cli";
  version = "2024.7.2";

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "clients";
    rev = "cli-v${version}";
    hash = "sha256-MqIznJe5GeRTJ+sgOJoTHAQaac0obuBDb63XxQeG1iY=";
  };

  inherit nodejs;

  npmDepsHash = "sha256-XDN92VPKTA9KeSg5CQXxhXyEARZBwpERZ3400xqwg7U=";

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
