nix-build := 'NIXPKGS_ALLOW_BROKEN=1 nom-build --keep-failed'

_default:

_run-shell COMMAND *ARGS:
  nix-shell {{ARGS}} --run '{{COMMAND}}'

init: (_run-shell 'init')
switch: (_run-shell 'switch')
copy-package SRC DST: (_run-shell ('copyPackage ' + quote(SRC) + ' ' + quote(DST)))
list-packages: (_run-shell 'listPackages')
option PATH: (_run-shell ('showOption ' + quote(PATH)))
check: (_run-shell 'checkUpdates' '--arg doWarn true')

build:
  nom-build

build-package ATTR:
  {{nix-build}} -A pkgs.{{ATTR}}
build-home-package ATTR:
  {{nix-build}} -A homePackages.{{ATTR}}
build-program-package NAME ATTR='package':
  {{nix-build}} -A config.programs.{{NAME}}.{{ATTR}}

update-package ATTR *ARGS:
  nix-update "pkgs.{{ATTR}}" {{ARGS}}

update-neovim: (update-package 'kiwiPackages.neovim' '--version=branch=master')

repl:
  nix repl --expr '(import ./default.nix { }).env'

update *NAMES:
  npins update {{NAMES}}

commit-update NAMES:
  git add npins && git commit -m 'chore(deps): Update ({{NAMES}})'

update-nur:
  npins -d npins/nur update
  -git add npins/nur && git commit -m 'chore(deps): Update NUR'

push:
  git push -f origin main

clean:
  -rm result*
