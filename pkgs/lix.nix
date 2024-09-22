{ lib

, fetchpatch
, fetchzip
, srcOnly
}:
let
  version = "2.91.0";

  fetchSource = {
    repo,
    hash ? lib.fakeHash,

    patches ? [ ],
    pullRequests ? [ ],
  }: let
    baseUrl = "https://git.lix.systems/lix-project/${repo}";

    finalPatches = let
      fetchPullRequest = {
        id,
        hash ? lib.fakeHash,
      }: fetchpatch {
        name = "${repo}-pull-${toString id}";
        url = "${baseUrl}/pulls/${toString id}.patch";
        inherit hash;
      };
    in (map fetchPullRequest pullRequests) ++ patches;

  in srcOnly {
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
    hash = "sha256-Rosl9iA9MybF5Bud4BTAQ9adbY81aGmPfV8dDBGl34s=";
  };
  nixos-module = fetchSource {
    repo = "nixos-module";
    hash = "sha256-zNW/rqNJwhq2lYmQf19wJerRuNimjhxHKmzrWWFJYts=";

    pullRequests = [
      {
        id = 34;
        hash = "sha256-DWJm2aeI3wwmxrkK2YwiFcOdT2MX2BZ2CYm7Ym+bAWk=";
      }
    ];
  };
}
