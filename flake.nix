{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem = { pkgs, ... }:
      let
        zigpeg = pkgs.stdenv.mkDerivation {
          pname = "zigpeg";
          version = "dev";

          src = ./.;

          nativeBuildInputs = [
            pkgs.zig_0_13.hook
          ];

          zigBuildFlags = [
            "-Doptimize=Debug"
          ];
        };
      in
      {
        treefmt = {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true;
          programs.zig.enable = true;
          programs.actionlint.enable = true;
        };

        checks = {
          inherit zigpeg;
        };

        packages = {
          inherit zigpeg;
          default = zigpeg;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.zig_0_13
            pkgs.zls
            pkgs.nil
          ];
        };
      };
    };
}
