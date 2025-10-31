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

            shellFunctions = ''
              testcmd() {
                ./ci_scripts/all_tests.sh
              }
              export -f testcmd
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
                      export ROC=roc

                      ${shellFunctions}
                      
                      echo "Some convenient commands:"
                      echo "${shellFunctions}" | grep -E '^\s*[a-zA-Z_][a-zA-Z0-9_]*\(\)' | sed 's/().*//' | sed 's/^[[:space:]]*/  /' | while read func; do
                        body=$(echo "${shellFunctions}" | sed -n "/''${func}()/,/^[[:space:]]*}/p" | sed '1d;$d' | tr '\n' ';' | sed 's/;$//' | sed 's/[[:space:]]*$//')
                        echo "  $func = $body"
                      done
                      echo ""
                    '';
                };
            });
}
