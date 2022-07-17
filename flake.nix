{
  description = "Jason's portable home";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?rev=0432195a4b8d68faaa7d3d4b355260a3120aeeae";
    nixpkgs2205.url = "github:nixos/nixpkgs/22.05";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { flake-compat, flake-utils, nixpkgs, nixpkgs2205, self }:
    flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ]
      (system:
        let
          rootDir = builtins.toString ./.;
          pkgs = import nixpkgs { inherit system; };
          pkgs2205 = import nixpkgs2205 { inherit system; };
          buildInputs = (with pkgs; [
            ansible
            awscli
            crane
            curl
            docker
            git
            git-crypt
            nix
            python3Full
            tmux
            which
          ]) ++ (with pkgs2205; [ deno ]);
          shellHook = ''
            PS1="\[\033[0;31m\][$(echo '\[\033[01;96m\]\h')\[\033[0;31m\]:\[\033[0;32m\]\W\[\033[0;31m\]]\[\033[0m\]\[\e[01;33m\]\\$ \[\e[0m\]"
          '';
        in
        {
          devShell = pkgs.mkShell {
            inherit buildInputs;
            inherit shellHook;
          };

          defaultPackage = pkgs.stdenv.mkDerivation {
            name = "git-home";
            src = self;
            buildPhase = "";
            installPhase = "mkdir $out";
          };
        }
      );
}
