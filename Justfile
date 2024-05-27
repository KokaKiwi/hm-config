nix-build := 'NIXPKGS_ALLOW_BROKEN=1 nom-build --keep-failed'

_default:

_run-shell COMMAND *ARGS:
  nix-shell {{ARGS}} --run '{{COMMAND}}'

init: (_run-shell 'init')
switch: (_run-shell 'switch')
list-packages: (_run-shell 'listPackages')
check: (_run-shell 'checkUpdates' '--arg doWarn true')

build:
  nom-build

build-package ATTR:
  {{nix-build}} -A pkgs.{{ATTR}}
build-home-package ATTR:
  {{nix-build}} -A homePackages.{{ATTR}}
build-program-package NAME ATTR='package':
  {{nix-build}} -A config.programs.{{NAME}}.{{ATTR}}

copy-package SRC DST:
  mkdir -p $(dirname pkgs/{{DST}})
  cp -Tr ~/.local/state/nix/defexpr/50-home-manager/nixpkgs-unstable/pkgs/{{SRC}} pkgs/{{DST}}
  chmod -R +w pkgs/{{DST}}

update-package ATTR *ARGS:
  nix-update "pkgs.{{ATTR}}" {{ARGS}}

update-neovim: (update-package 'kiwiPackages.neovim' '--version=branch=master')
  -git add pkgs/kiwi-packages/neovim && git commit -m 'pkgs(neovim): Update revision'

option PATH='':
  nixos-option \
    --options_expr '(import ./default.nix {}).options' \
    --config_expr '(import ./default.nix {}).config' \
    {{PATH}}

repl:
  nix repl --expr '(import ./default.nix { }).env'

update *NAMES:
  npins update {{NAMES}}

commit-update NAMES:
  git add npins && git commit -m 'chore(deps): Update ({{NAMES}})'

update-nur:
  npins -d npins/nur update
  -git add npins/nur && git commit -m 'chore(deps): Update NUR'

update-channels:
  npins -d npins/channels update
  -git add npins/channels && git commit -m 'chore: Update channels'

push:
  git push -f origin main

clean:
  -rm result*
