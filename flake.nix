{
  description = "flake for hiarthurbr with Home Manager enabled";

  inputs = {
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
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
    nur = {
      url = "github:nix-community/NUR";
      inputs.nix.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      home-manager,
      nixpkgs,
      nur,
      self,
      ...
    }:
    let
      env = import ./env.nix;

 #     nixpkgs = {
 #       pkgs = import inputs.nixpkgs {
 #         system = env.system;
#          config = {
#            allowUnfree = env.allowUnfree;
#          };
#        };
#      } // nixpkgs;

      unstable = import inputs.nixpkgs-unstable {
        system = env.system;
        config = {
          allowUnfree = env.allowUnfree;
        };
      };
    in
    {
      nixosConfigurations."${env.systemName}" = nixpkgs.lib.nixosSystem {
        system = env.system;
        specialArgs = {
          inherit
            inputs
            unstable
            env
            self
            ;
        };

        modules = [
          # (
          #   { pkgs, ... }:
          #   {
          #     nixpkgs.overlays = [ self.overlays.pinned ];
          #     boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

          #     # Binary cache
          #     nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
          #     nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

          #     # ... your other configs
          #   }
          # )
          ./configuration.nix
          nur.modules.nixos.default
          nur.legacyPackages."${env.system}".repos.iopq.modules.xraya
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "home-mngr-backup";
            home-manager.extraSpecialArgs = {
              inherit inputs unstable env;
              system = env.system;
            };

            # home-manager.users.${username} = { ... }: {
            #   home = {
            #     inherit username;
            #     homeDirectory = "/home/${username}";
            #   };
            #   programs.home-manager.enable = true;

            #   imports = [ ./${username}.nix ];
            #   home.stateVersion = "23.05";
            # };

            home-manager.users = builtins.mapAttrs (username: _: {
              home = {
                inherit username;
                stateVersion = env.stateVersion;
                homeDirectory = "/home/${username}";
              };
              programs.home-manager.enable = true;

              imports = [
                # ./users/${username}/home.nix
                # { pkgs, system, inputs, env, unstable, config, lib, specialArgs, options, modulesPath, _class, nixosConfig, osConfig, osClass }
                (
                  args@{ pkgs, lib, ... }:
                  let
                    mod = (args // { inherit pkgs; });
                  in
                  (import ./users/${username}/home.nix mod)
                  // {
                    home.packages = import ./users/${username}/packages.nix mod;
                    programs =
                      lib.attrsets.mapAttrs'
                        (
                          name: _:
                          lib.attrsets.nameValuePair (builtins.substring 0 (builtins.stringLength name - 4) name) (
                            import ./users/${username}/programs/${name} mod
                          )
                        )
                        (
                          if builtins.pathExists ./users/${username}/programs then
                            (builtins.readDir ./users/${username}/programs)
                          else
                            { }
                        );
                  }
                )
              ];
            }) (builtins.readDir ./users);
          }
        ];
      };
    };
}
