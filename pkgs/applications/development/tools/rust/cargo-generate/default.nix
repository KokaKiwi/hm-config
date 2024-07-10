{ lib

, fetchFromGitHub

, rustPlatform

, pkg-config
, libgit2
, openssl

, git
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-generate";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "cargo-generate";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "sha256-hh+MZb0LzzJb6D3OHZdiqxgG/e8yt33nl+40PC46cSw=";
  };

  cargoHash = "sha256-n7ILQBizLOiJ20KCNDzmHRKhl+hjc7/bdAmf9w5VXRk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 openssl ];

  nativeCheckInputs = [ git ];

  # disable vendored libgit2 and openssl
  buildNoDefaultFeatures = true;

  preCheck = ''
    export HOME=$(mktemp -d) USER=nixbld
    git config --global user.name Nixbld
    git config --global user.email nixbld@localhost.localnet
  '';

  # Exclude some tests that don't work in sandbox:
  # - favorites_default_to_git_if_not_defined: requires network access to github.com
  # - should_canonicalize: the test assumes that it will be called from the /Users/<project_dir>/ folder on darwin variant.
  checkFlags = [
    "--skip=favorites::favorites_default_to_git_if_not_defined"
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = with lib; {
    description = "Tool to generate a new Rust project by leveraging a pre-existing git repository as a template";
    mainProgram = "cargo-generate";
    homepage = "https://github.com/cargo-generate/cargo-generate";
    changelog = "https://github.com/cargo-generate/cargo-generate/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda turbomack matthiasbeyer ];
  };
}
