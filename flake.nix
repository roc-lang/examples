{
  description = "A very basic flake";
  
  inputs = {
    roc.url = "github:roc-lang/roc";
    nixpkgs.follows = "roc/nixpkgs";

    # to easily make configs for multiple architectures
    flake-utils.url = "github:numtide/flake-utils";

    # rust is used for the static-site-gen platform
    # rust from nixpkgs has some libc problems, this is patched in the rust-overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, roc }:
    let
      supportedSystems = [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    in
      flake-utils.lib.eachSystem supportedSystems (system:
        let
            overlays = [ (import rust-overlay) ];

            pkgs = import nixpkgs {
              inherit system overlays;
            };

            rocPkgs = roc.packages.${system};

            customRust =
              pkgs.rust-bin.stable."1.72.1".default; # keep this in sync with https://github.com/roc-lang/roc/blob/main/rust-toolchain.toml

            linuxInputs = with pkgs;
              lib.optionals stdenv.isLinux [
                #valgrind # for debugging
                #gdb # for debugging
              ];
        in
            {
                devShell = pkgs.mkShell {
                    packages = with pkgs; [
                      rocPkgs.cli
                      simple-http-server # to be able to view the website when developing
                      expect # to test examples on CI
                      customRust # for static-site-gen platform
                      perl # for ci/update_basic_cli_url.sh
                      go # for GoPlatform example
                      dotnet-sdk_8 # for DotnetPlatform example
		                ] ++ linuxInputs;

                    # nix does not store libs in /usr/lib or /lib
                    # for libgcc_s.so.1
                    NIX_LIBGCC_S_PATH =
                      if pkgs.stdenv.isLinux then "${pkgs.stdenv.cc.cc.lib}/lib" else "";
                    # for crti.o, crtn.o, and Scrt1.o
                    NIX_GLIBC_PATH =
                      if pkgs.stdenv.isLinux then "${pkgs.glibc.out}/lib" else "";
                };
            });
}
