{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, flake-utils, nixpkgs, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      systemDeps = with pkgs; [
        nodejs-18_x

        # node2nix  # TODO

        esbuild
        nodePackages.eslint
        vsce

        nodePackages.typescript
      ];
      devDeps = with pkgs; [
        nodePackages.typescript-language-server
        just

        jq
        # tyson          # https://github.com/jetify-com/tyson
        # jid            # https://github.com/simeji/jid
        # dyff           # https://github.com/homeport/dyff
        # jd-diff-patch  # https://github.com/josephburnett/jd
        # dsq            # https://github.com/multiprocessio/dsq
      ];
    in
    rec {
      formatter = pkgs.nixpkgs-fmt;

      devShells.default = pkgs.mkShell {
        buildInputs = devDeps;
      };
    });
}
