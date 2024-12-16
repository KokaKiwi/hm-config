host := `cat /etc/hostname`

nix-build := 'NIXPKGS_ALLOW_BROKEN=1 nom-build'

alias upp := update-package
alias upk := update-kiwi-package

_default:

_run-shell COMMAND *ARGS:
  nix-shell {{ARGS}} --run '{{COMMAND}}'

run COMMAND *ARGS: (_run-shell COMMAND ARGS)
init: (_run-shell 'init')
list-packages: (_run-shell 'listPackages')
check: (_run-shell 'checkUpdates' '--arg doWarn true')

build:
  nom-build -A hosts.{{host}}

activate:
  result/activate
dry-activate: build
  DRY_RUN=1 result/activate
switch: build activate

build-package ATTR:
  {{nix-build}} -A pkgs.{{ATTR}}
build-host-package ATTR:
  {{nix-build}} -A hosts.{{host}}.config.{{ATTR}}

copy-package SRC DST:
  mkdir -p $(dirname pkgs/{{DST}})
  cp -Tr ~/.local/state/nix/defexpr/50-home-manager/nixpkgs-unstable/pkgs/{{SRC}} pkgs/{{DST}}
  chmod -R +w pkgs/{{DST}}
copy-application SRC DST: (copy-package (SRC) ('applications/' + DST))

update-package ATTR *ARGS:
  nix-update --commit pkgs.{{ATTR}} {{ARGS}}
update-kiwi-package ATTR *ARGS:
  nix-update --commit pkgs.kiwiPackages.{{ATTR}} {{ARGS}}
update-config-package ATTR *ARGS:
  nix-update --commit hosts.{{host}}.config.{{ATTR}} {{ARGS}}

update-neovim: (update-package 'kiwiPackages.neovim' '--version=branch=master')
update-vscode:
  nix-update --commit hosts.kira.config.programs.vscode.package --override-filename ./pkgs/kiwi-packages/vscodium/default.nix

option PATH='':
  nixos-option \
    --options_expr '(import ./default.nix {}).hosts.{{host}}.options' \
    --config_expr '(import ./default.nix {}).hosts.{{host}}.config' \
    {{PATH}}

repl:
  nix repl -f default.nix

update *NAMES:
  npins update {{NAMES}}
  -git add npins/sources.json && git commit -m 'chore: Update pinned sources'

update-nur:
  npins -d npins/nur update
  -git add npins/nur && git commit -m 'chore(deps): Update NUR'

update-channels:
  npins -d npins/channels update
  -git add npins/channels && git commit -m 'chore: Update channels'

upload-cache:
  attic push kokakiwi result/home-path/

push:
  git push -f origin main

clean:
  -rm result*

import? 'Justfile.local'
