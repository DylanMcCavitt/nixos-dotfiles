{
  description = "NixOS + Home Manager + nvf (desktop & laptop)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-colors = {
      url = "github:Misterio77/nix-colors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nvf,
    nix-colors,
    sops-nix,
    ...
  }: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    pkgs = nixpkgs.legacyPackages.${system};
    pkgsUnstable = nixpkgs-unstable.legacyPackages.${system};

    mkHost = name:
      lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit pkgsUnstable nix-colors;
        };

        modules = [
          ./hosts/${name}/configuration.nix
          ./modules/system/common.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            nixpkgs.config.allowUnfree = true;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit pkgsUnstable nix-colors;
              };

              users.dylan = {
                imports = [
                  nvf.homeManagerModules.default
                  ./modules/home/theme.nix
                  ./modules/home/common.nix
                  ./modules/home/nvf.nix
                  ./hosts/${name}/home.nix
                ];
              };

              backupFileExtension = "backup";
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      desktop = mkHost "desktop";
      laptop = mkHost "laptop";
    };
  };
}
