{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    # to easily make configs for multiple architectures
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      supportedSystems = [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    in
      flake-utils.lib.eachSystem supportedSystems (system:
        let

            pkgs = import nixpkgs {
              inherit system;
            };
        in
            {
                devShell = pkgs.mkShell {
                    packages = [
                      pkgs.simple-http-server # to be able to view the website when developing
                      pkgs.expect # to test examples on CI
		                ];

                    # nix does not store libs in /usr/lib or /lib
                    NIX_GLIBC_PATH =
                      if pkgs.stdenv.isLinux then "${pkgs.glibc.out}/lib" else "";
                };
            });
}
