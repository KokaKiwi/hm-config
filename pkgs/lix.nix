{ lib, stdenvNoCC

, fetchpatch
, fetchzip
, srcOnly
}:
let
  lixVersion = "2.91.1";

  fetchSource = {
    repo,
    version ? lixVersion,
    hash ? lib.fakeHash,

    patches ? [ ],
    cherryPicks ? [ ],
    pullRequests ? [ ],
  }: let
    baseUrl = "https://git.lix.systems/lix-project/${repo}";

    finalPatches = let
      fetchCherryPick = {
        id,
        hash ? lib.fakeHash,
      }: fetchpatch {
        name = "${repo}-commit-${lib.strings.substring 0 8 id}";
        url = "${baseUrl}/commit/${id}.patch";
        inherit hash;
      };
      fetchPullRequest = {
        id,
        hash ? lib.fakeHash,
      }: fetchpatch {
        name = "${repo}-pull-${toString id}";
        url = "${baseUrl}/pulls/${toString id}.patch";
        inherit hash;
      };
    in
    (map fetchCherryPick cherryPicks)
    ++ (map fetchPullRequest pullRequests)
    ++ patches;

  in srcOnly {
    stdenv = stdenvNoCC;

    name = "${repo}-source";

    src = fetchzip {
      name = "${repo}-base-source";
      url = "${baseUrl}/archive/${version}.tar.gz";
      inherit hash;
    };

    patches = finalPatches;
  };
in {
  lix = fetchSource {
    repo = "lix";
    hash = "sha256-hiGtfzxFkDc9TSYsb96Whg0vnqBVV7CUxyscZNhed0U=";
  };
  nixos-module = fetchSource {
    repo = "nixos-module";
    version = "${lixVersion}-2";
    hash = "sha256-DN5/166jhiiAW0Uw6nueXaGTueVxhfZISAkoxasmz/g=";
  };
}
