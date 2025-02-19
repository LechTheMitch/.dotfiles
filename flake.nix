{
  description = "Home Manager configuration of gamal";
  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl = {
      url = "github:johanneshorner/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    };


  outputs = { nixpkgs, nixpkgs-stable, nixgl, home-manager, self, flake-utils, system-manager, ... }@inputs:



    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nixgl.overlay
        ];
        };

      setup = {
          wsl = false;
          basicSetup = false;
          isNixOS = false;
          isVirtualBox = false;
        };
      
    in {
      homeConfigurations."gamal" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { 
          # Pass all inputs to every module. It's a bit excessive, but allows us to easily refer
          # to stuff like inputs.nixgl.
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit nixgl;
          inherit inputs; 
          };
        
      };
      systemConfigs.default = system-manager.lib.makeSystemConfig {
      modules = [
        ./modules
        ];
      };
    };
  
}
