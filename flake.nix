{
  description = "Simple start scree";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      plugin-overlay = final: prev: {
        starter-nvim = final.pkgs.vimUtils.buildVimPlugin {
          name = "starter.nvim";
          src = self;
        };
      };

      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            plugin-overlay
          ];
        };
      in
      {
        packages = rec {
          default = starter-nvim;
          inherit (pkgs) starter-nvim;
        };
      }
    )
    // {
      overlays.default = plugin-overlay;
    };
}
