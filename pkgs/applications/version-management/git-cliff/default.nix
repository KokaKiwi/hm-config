{ lib

, fetchFromGitHub

, installShellFiles
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-GRvZ9jdooduFylTGgUQNjdnD2Aa+jT5faV0/c3GBpqw=";
  };

  cargoHash = "sha256-vgVTHTEKfjWJzxDQ5w0dwp9qxyN5sgbBseXHN25bx9o=";

  nativeBuildInputs = [
    installShellFiles
  ];

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  postInstall = ''
    mkdir generated

    OUT_DIR=generated $out/bin/git-cliff-completions
    OUT_DIR=generated $out/bin/git-cliff-mangen

    installManPage generated/git-cliff.1
    installShellCompletion \
      --bash generated/git-cliff.bash \
      --fish generated/git-cliff.fish \
      --zsh generated/_git-cliff

    rm $out/bin/git-cliff-*
  '';

  meta = with lib; {
    description = "Highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    changelog = "https://github.com/orhun/git-cliff/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ siraben ];
    mainProgram = "git-cliff";
  };
}