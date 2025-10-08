{
  description = "CKAD Study Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      in {
        devShells.default = pkgs.mkShell {
          name = "ckad";

          buildInputs = with pkgs; [
            kubectl
            kubernetes-helm

            pre-commit
            just
            direnv
            zsh
          ];
        };
      });
}

