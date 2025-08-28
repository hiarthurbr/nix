{
  description = "flake for hiarthurbr with Home Manager enabled";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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
    unstable,
    ...
  }:
  let
    system = "x86_64-linux";
    username = "hiarthurbr";
    pkgs-unstable = inputs.unstable.legacyPackages.${system};
  in {
    nixosConfigurations = {
      hiarthurbr-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "${username}-home";
            home-manager.extraSpecialArgs = { inherit inputs system pkgs-unstable unstable; };

            home-manager.users.${username} = { pkgs, ... }: {
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
              };
              programs.home-manager.enable = true;

              imports = [
                ./${username}.nix
              ];
              home.stateVersion = "23.05";
            };
          }
        ];
      };
    };
  };
}
