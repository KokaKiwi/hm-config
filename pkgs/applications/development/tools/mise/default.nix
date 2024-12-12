{ lib

, fetchFromGitHub

, installShellFiles
, addUsageCompletion
, rustPlatform

, pkg-config

, coreutils
, bash
, direnv
, gnused
, git
, gawk
, openssl
}: rustPlatform.buildRustPackage rec {
  pname = "mise";
  version = "2024.12.8";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    rev = "v${version}";
    hash = "sha256-v5NtoJ+g0Ja8CfvhAgad3zLJUoA3GNEnxK2NiAqqahg=";
  };

  cargoHash = "sha256-dYczM3MP77E2CoE84yd5maSPh1z/s3tbF6mxio/Epj0=";

  nativeBuildInputs = [ addUsageCompletion installShellFiles pkg-config ];
  buildInputs = [
    coreutils
    bash
    direnv
    gnused
    git
    gawk
    openssl
  ];

  prePatch = ''
    substituteInPlace ./src/test.rs ./test/data/plugins/**/bin/* \
      --replace-warn '/usr/bin/env bash' '${bash}/bin/bash'
    substituteInPlace ./src/fake_asdf.rs ./src/cli/generate/git_pre_commit.rs ./src/cli/generate/snapshots/*.snap \
      --replace-warn '/bin/sh' '${bash}/bin/sh'
    substituteInPlace ./src/env_diff.rs \
      --replace-warn '"bash"' '"${bash}/bin/bash"'
    substituteInPlace ./src/cli/direnv/exec.rs \
      --replace-warn '"env"' '"${coreutils}/bin/env"' \
      --replace-warn 'cmd!("direnv"' 'cmd!("${direnv}/bin/direnv"'
    substituteInPlace ./src/git.rs ./src/test.rs \
      --replace-warn '"git"' '"${git}/bin/git"'
  '';

  cargoTestFlags = [ "--all-features" ];
  dontUseCargoParallelTests = true;
  checkFlags = let
    skipTests = [
      "cli::plugins::ls::tests::test_plugin_list_urls"
      "tera::tests::test_last_modified"
      "plugins::core::ruby::tests::test_list_versions_matching"
    ];
  in map (name: "--skip=${name}") skipTests;

  postInstall = ''
    installManPage ./man/man1/mise.1

    addUsageCompletion "mise" ./completions "$out/bin/mise usage"

    installShellCompletion \
      --bash ./completions/mise.bash \
      --fish ./completions/mise.fish \
      --zsh ./completions/_mise
  '';

  meta = with lib; {
    homepage = "https://mise.jdx.dev";
    description = "The front-end to your dev env";
    changelog = "https://github.com/jdx/mise/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "mise";
  };
}
