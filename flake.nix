{
  description = "Kubestronaut Study Environment";

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
          name = "kubestronaut";

          buildInputs = with pkgs; [
            kubectl
            kubernetes-helm
            k9s
            kind
            trivy
            jq
            yq
          ];
        };
      });
}
