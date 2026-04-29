{
  description = "Môi trường phát triển cho dự án Python";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {

            packages = with pkgs; [
              nodejs
              yarn
              cargo 
              rustc
              gcc
              python3
              python3Packages.python-lsp-server
              python3Packages.python-lsp-black
              python3Packages.pyls-isort
              python3Packages.pandas
              python3Packages.numpy
              python3Packages.python-dotenv
              python3Packages.pymongo
              python3Packages.pydantic-core
              python3Packages.pydantic
              python3Packages.uvicorn
              python3Packages.fastapi
              python3Packages.reportlab
              python3Packages.scipy
              python3Packages.python-multipart
            ];

            shellHook = ''
              echo "🚀 Môi trường phát triển Python đã sẵn sàng!"
              python --version
            '';
          };
        }
      );
    };
}
