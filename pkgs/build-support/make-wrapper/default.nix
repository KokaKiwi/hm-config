{ lib, runCommand, makeWrapper }:
rec {
  wrapProgram = name: {
    program,
    args ? [ ],
    prefix ? null,
  }: let
    outName = if prefix != null then "$out${prefix}/${name}" else "$out";
  in runCommand name {
    nativeBuildInputs = [ makeWrapper ];
  } ''
    mkdir -p $(dirname "${outName}")
    makeWrapper ${program} "${outName}" ${lib.concatStringsSep " " args}
  '';

  wrapProgramBin = name: args: wrapProgram name (args // { prefix = "/bin"; });
}
