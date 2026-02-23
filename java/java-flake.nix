{
  description = "Java development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        javaVersion = 25;
        mavenVersion = "3"; # nixpkgs chỉ có "maven" không có version cụ thể

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              jdk = prev."jdk${toString javaVersion}";
              maven = prev.maven.override {
                jdk_headless = prev."jdk${toString javaVersion}";
              };
            })
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            jdk
            maven
            liquibase
            postgresql_jdbc
            tree #for view tree
          ];

          shellHook = ''
            export JAVA_HOME=${pkgs.jdk.home}

            echo "------------------------------------------"
            echo "🚀 Java ${toString javaVersion}, Maven & Liquibase Shell Active"
            echo "JDK Path: $JAVA_HOME"
            java -version
            mvn -version
            echo "Liquibase Version:"
            liquibase --version
            echo "------------------------------------------"
          '';
        };

        checks = {
          build = pkgs.stdenv.mkDerivation {
            name = "java-project-test";
            src = ./.;
            buildInputs = [
              pkgs.jdk
              pkgs.maven
            ];
            buildPhase = "mvn test";
            installPhase = "touch $out";
          };
        };
      }
    );
}
