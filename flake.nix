{
  description = "flake for hiarthurbr with Home Manager enabled";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    home-manager,
    zen-browser,
    nixpkgs,
    sops-nix,
    ...
  }:
  let
    system = "x86_64-linux";
    username = "hiarthurbr";
    unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config = {
        allowFree = true;
      };
    };
  in {
    nixosConfigurations = {
      hiarthurbr-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs unstable; };

        modules = [
          (with username; ./configuration.nix)
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "${username}-home";
            home-manager.extraSpecialArgs = { inherit inputs system unstable; };

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
