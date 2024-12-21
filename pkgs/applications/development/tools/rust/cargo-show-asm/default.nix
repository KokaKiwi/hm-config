{ lib

, fetchCrate

, rustPlatform
, installShellFiles
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-show-asm";
  version = "0.2.44";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-X4ZmG/v1bN8sNCSvnhyPmppH7x4T8Wvi4dOVJSneZ/s=";
  };

  cargoHash = "sha256-8DOjS2X+dr8eQs/JD8dpduz8fAwSQPldHESDIbDRYtc=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd cargo-asm \
      --bash <($out/bin/cargo-asm --bpaf-complete-style-bash) \
      --fish <($out/bin/cargo-asm --bpaf-complete-style-fish) \
      --zsh  <($out/bin/cargo-asm --bpaf-complete-style-zsh)
  '';

  meta = with lib; {
    description = "Cargo subcommand showing the assembly, LLVM-IR and MIR generated for Rust code";
    homepage = "https://github.com/pacak/cargo-show-asm";
    changelog = "https://github.com/pacak/cargo-show-asm/blob/${version}/Changelog.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda oxalica matthiasbeyer ];
    mainProgram = "cargo-asm";
  };
}
