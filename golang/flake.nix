{
  description = "Môi trường phát triển cho dự án Go";

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
              go # Trình biên dịch Go
              gopls # Go Language Server (hỗ trợ code completion cho editor)
              gotools # Chứa các tool như goimports
              gofumpt # Trình format code Go chặt chẽ hơn gofmt
              golangci-lint # Linter phổ biến cho Go
              exercism
              nodejs
              yarn
              python3
              python3Packages.python-lsp-server
              python3Packages.python-lsp-black
              python3Packages.pyls-isort
              python3Packages.pandas
              python3Packages.numpy
              python3Packages.python-dotenv
              python3Packages.pymongo
            ];

            shellHook = ''
              echo "🚀 Môi trường phát triển Go đã sẵn sàng!"
              go version
            '';
          };
        }
      );
    };
}
