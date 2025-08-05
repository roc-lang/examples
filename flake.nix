{
  description = "A very basic flake";
  
  inputs = {
    roc.url = "github:roc-lang/roc";
    
    nixpkgs.follows = "roc/nixpkgs";

    # to easily make configs for multiple architectures
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, roc }:
    let
      supportedSystems = [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    in
      flake-utils.lib.eachSystem supportedSystems (system:
        let

            pkgs = import nixpkgs {
              inherit system;
            };

            rocPkgs = roc.packages.${system};

            aliases = ''
              alias testcmd='export ROC=roc && ./ci_scripts/all_tests.sh'
            '';

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
                      rocPkgs.lang-server
                      expect # to test examples on CI
                      perl # for ci/update_basic_cli_url.sh
                      go # for GoPlatform example
                      dotnet-sdk_8 # for DotnetPlatform example
                      elmPackages.elm # for ElmWebApp example
		                ] ++ linuxInputs;

                    # nix does not store libs in /usr/lib or /lib
                    # for libgcc_s.so.1
                    NIX_LIBGCC_S_PATH =
                      if pkgs.stdenv.isLinux then "${pkgs.stdenv.cc.cc.lib}/lib" else "";
                    # for crti.o, crtn.o, and Scrt1.o
                    NIX_GLIBC_PATH =
                      if pkgs.stdenv.isLinux then "${pkgs.glibc.out}/lib" else "";

                    shellHook = ''
                      ${aliases}
                      
                      echo "Some convenient command aliases:"
                      echo "${aliases}" | grep -E "alias .*" -o | sed 's/alias /  /' | sed 's/=/ = /'
                      echo ""
                    '';
                };
            });
}
