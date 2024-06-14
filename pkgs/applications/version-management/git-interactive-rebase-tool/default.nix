{ lib

, fetchFromGitHub

, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "git-interactive-rebase-tool";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "MitMaro";
    repo = pname;
    rev = version;
    sha256 = "sha256-xwvL6QX+eMbxCouE1i86j/PRCxTJVAQnRVeK6fYQo/M=";
  };

  cargoHash = "sha256-RDGbsmOBVMxInstTrRZK0G5eZR79ZoFK5UlkCj3zpoY=";

  # Compilation during tests fails if this env var is not set.
  preCheck = "export GIRT_BUILD_GIT_HASH=${version}";
  postCheck = "unset GIRT_BUILD_GIT_HASH";
  cargoTestFlags = [
    "--workspace"
    # build everything except for doctests which are currently broken because
    # `config::lib` expects the sourcetree to be a git repo.
    "--tests"
    "--bins"
  ];

  meta = with lib; {
    homepage = "https://github.com/MitMaro/git-interactive-rebase-tool";
    description = "Native cross platform full feature terminal based sequence editor for git interactive rebase";
    changelog = "https://github.com/MitMaro/git-interactive-rebase-tool/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 zowoq ma27 ];
    mainProgram = "interactive-rebase-tool";
  };
}
