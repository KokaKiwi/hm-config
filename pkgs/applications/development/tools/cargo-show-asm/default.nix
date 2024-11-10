{ lib

, fetchCrate

, rustPlatform
, installShellFiles
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-show-asm";
  version = "0.2.42";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-3KdHEmoGdtfc5b5H7EQ1q5vqra0hRrROJYCIpiqxshk=";
  };

  cargoHash = "sha256-GwzGdy6aWnKyaQbtgRB6t0cnWWiirN9j/GqhdBc5fHU=";

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
