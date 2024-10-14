{
  description = "Home Manager configuration of gamal";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
       nixGL = {
      url = "github:nix-community/nixGL/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    };


  outputs = { nixpkgs, nixGL, home-manager, ... }@inputs:



    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
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
          inherit inputs; 
          };

        # You can now reference pkgs.nixgl.nixGLIntel, etc.

          # but NIX_PATH is still used by many useful tools, so we set it to the same value as the one used by this flake.
        # Make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
#         environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
        # https://github.com/NixOS/nix/issues/9574
#         nix.settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";

        
      };
    };
  
}
