{
  description = "flake for hiarthurbr with Home Manager enabled";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    zen-browser,
    ...
  }: {
    nixosConfigurations = {
      hiarthurbr-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "home";
            home-manager.extraSpecialArgs = { inherit inputs; system = "x86_64-linux"; };

            home-manager.users.hiarthurbr = { pkgs, ... }: {
              home.username = "hiarthurbr";
              home.homeDirectory = "/home/hiarthurbr";
              programs.home-manager.enable = true;

              imports = [
                ./hiarthurbr.nix
              ];
              home.stateVersion = "23.05";
            };
          }
        ];
      };
    };
  };
}
