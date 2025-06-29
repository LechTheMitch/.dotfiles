{ config, inputs, pkgs, pkgs-stable, nixgl, ... }:


let

in
{

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "gamal";
  home.homeDirectory = "/home/gamal";
  targets.genericLinux.enable = true;
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
    };
  nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
    vulkan.enable = true;
  };
  #nixpkgs. android_sdk.accept_license = true;
  home.file.".icons/default".source = "${pkgs.kdePackages.breeze}/share/icons/breeze_cursors";
  home.file.".config/paru/paru.conf".source = ./linkedDotfiles/paru.conf;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  fonts.fontconfig.enable = true;
  home.packages = with pkgs;[
    pkgs.nixgl.nixGLIntel
    pkgs.nixgl.nixVulkanIntel
    (config.lib.nixGL.wrap vscode)
    (config.lib.nixGL.wrap github-desktop)
    (config.lib.nixGL.wrap codeblocks)
    (config.lib.nixGL.wrap netbeans)
    (config.lib.nixGL.wrap zed-editor)
    android-tools
    kdePackages.breeze
    #(config.lib.nixGL.wrap android-studio)
#     (config.lib.nixGL.wrap (jetbrains.plugins.addPlugins jetbrains.idea-ultimate ["github-copilot"]))
#     (config.lib.nixGL.wrap (jetbrains.plugins.addPlugins jetbrains.rust-rover ["github-copilot"]))
#     (config.lib.nixGL.wrap (jetbrains.plugins.addPlugins jetbrains.rider ["github-copilot"]))
#     (config.lib.nixGL.wrap (jetbrains.plugins.addPlugins jetbrains.phpstorm ["github-copilot"]))
#     (config.lib.nixGL.wrap (jetbrains.plugins.addPlugins jetbrains.pycharm-professional ["github-copilot"]))
#     (config.lib.nixGL.wrap (jetbrains.plugins.addPlugins jetbrains.clion ["github-copilot"]))
#Try again in 4 weeks
    (config.lib.nixGL.wrap jetbrains.idea-ultimate)
    (config.lib.nixGL.wrap jetbrains.rust-rover)
    (config.lib.nixGL.wrap jetbrains.rider)
    (config.lib.nixGL.wrap jetbrains.phpstorm)
    (config.lib.nixGL.wrap jetbrains.pycharm-professional)
    (config.lib.nixGL.wrap jetbrains.clion)
    neovim
    nodejs
    gns3-gui
    gns3-server
    megasync
    emacs-gtk
    glxinfo
    vistafonts
    corefonts
    fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    kdePackages.full
    (config.lib.nixGL.wrap (
    (pkgs.brave.override {
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--enable-features=TouchpadOverscrollHistoryNavigation,AcceleratedVideoDecodeLinuxZeroCopyGL,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder"
        "--no-default-browser-check"
      ];
    })
  ))
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs = {

    # Zsh Configuration
    zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
    ls="ls --color=auto";
    grep="grep --color=auto";
    yay = "paru";
    clean = "sudo pacman -Rcs $(pacman -Qdtq)";
    chargelimit-on="echo 1 | sudo tee /sys/bus/wmi/drivers/acer-wmi-battery/health_mode";
    chargelimit-off="echo 0 | sudo tee /sys/bus/wmi/drivers/acer-wmi-battery/health_mode";
    calibrate-on="echo 1 | sudo tee /sys/bus/wmi/drivers/acer-wmi-battery/calibration_mode";
    calibrate-off="echo 0 | sudo tee /sys/bus/wmi/drivers/acer-wmi-battery/calibration_mode";
    flakeupdate="nix flake update --flake ~/.dotfiles/";
    google-chrome="flatpak run com.google.Chrome";
    nixsudo="sudo --preserve-env=PATH env";
    homeupdate="home-manager switch --flake ~/.dotfiles/ --impure";
    hows-my-gpu="echo \"NVIDIA Dedicated Graphics\" | grep \"NVIDIA\" && lspci -nnk | grep \"VGA compatible controller.*NVIDIA\" -A 2 | grep \"Kernel driver in use\" && echo \"Intel Integrated Graphics\" | grep \"Intel\" && lspci -nnk | grep -m 1 \"VGA compatible controller.*Intel\" -A 3 | grep \"Kernel driver in use\" && echo \"Enable and disable the dedicated NVIDIA GPU with nvidia-enable and nvidia-disable\"";
    nvidia-enable="sudo virsh nodedev-reattach pci_0000_01_00_0 && echo \"GPU reattached (now host ready)\" && sudo rmmod vfio_pci vfio_pci_core vfio_iommu_type1 && echo \"VFIO drivers removed\" && sudo modprobe -i -a nvidia_drm nvidia_modeset nvidia_uvm nvidia && echo \"NVIDIA drivers added\"&& sudo systemctl start nvidia-persistenced  && echo \"COMPLETED!\"";
    nvidia-disable="sudo systemctl stop nvidia-persistenced && sudo rmmod nvidia_drm nvidia_modeset nvidia_uvm nvidia && echo \"NVIDIA drivers removed\" && sudo modprobe -i vfio_pci vfio_pci_core vfio_iommu_type1 && echo \"VFIO drivers added\" && sudo virsh nodedev-detach pci_0000_01_00_0 && echo \"GPU detached (now vfio ready)\" && echo \"COMPLETED!\"";
  };
   initContent = ''
    ${pkgs.fastfetch}/bin/fastfetch
  '';
   history = {
    size = 10000;
    #path = "${config.xdg.dataHome}/Clutter/.zsh/history";
      };
    oh-my-zsh = {
    enable = true;
    plugins = [ "git" ];
    theme = "robbyrussell";
  };
   };

   # Kitty Configuration
    kitty = {
      enable = true;
      package = (config.lib.nixGL.wrap pkgs.kitty);
      font.name="Fira Code SemiBold";
      settings = {
         font_size = 14;
         bold_font  = "auto";
         italic_font =  "auto";
         bold_italic_font ="auto";
         background_opacity = "0.5";
         background_blur = 1;
         confirm_os_window_close = 0;
         scrollback_lines = 9001;
         wheel_scroll_min_lines =1;
         enable_audio_bell = false;
         selection_foreground = "none";
         selection_background = "none";
         window_padding_width = 4;
         term = "kitty";
      };
      themeFile ="1984_dark";

 };

  # Git Configuration
  git={
	enable = true;
	package = pkgs.gitFull;
	lfs.enable = true;
        userName  = "LechTheMitch";
        userEmail = "104312143+LechTheMitch@users.noreply.github.com";
  };

  # FastFetch Configuration
  fastfetch={
    enable = true;
    package = pkgs.fastfetch;
    settings = {
      logo = {
    padding = {
      top = 1;
      left= 1;
    };
  };
  display = {
    separator = " 󰑃  ";
  };
  modules = [
   "break"
        {
          type = "os";
          key = " DISTRO";
          keyColor = "yellow";
        }
        {
          type = "kernel";
          key = "│ ├󰏖";
          keyColor = "yellow";
        }
        {
          type = "packages";
          key = "│ ├󰏖";
          keyColor = "yellow";
        }
        {
          type = "shell";
          key = "│ └";
          keyColor = "yellow";
        }
        {
          type = "wm";
          key = " DE/WM";
          keyColor = "blue";
        }
        {
          type = "wmtheme";
          key = "│ ├";
          keyColor = "blue";
        }
        {
    type= "icons";
    key= "│ ├󰀻";
    keyColor= "blue";
    }
    {
        type= "cursor";
        key= "│ ├";
        keyColor= "blue";
    }
    {
        type= "terminalfont";
        key= "│ ├";
        keyColor= "blue";
    }
    {
    type= "terminal";
    key= "│ └";
    keyColor= "blue";
    }
    {
    type= "host";
    key= "󰌢 SYSTEM";
    keyColor= "green";
    }
    {
    type = "cpu";
    key = "│ ├󰻠";
    keyColor = "green";
    }
    {
    type= "gpu";
    key= "│ ├󰻑";
    format= "{2}";
    keyColor= "green";
    }
    {
    type= "display";
    key= "│ ├󰍹";
    keyColor= "green";
    compactType= "original-with-refresh-rate";
    }
    {
    type= "memory";
    key= "│ ├󰾆";
    keyColor= "green";
    }
    {
    type= "swap";
    key= "│ ├󰓡";
    keyColor= "green";
    }
    {
    type= "uptime";
    key= "│ ├󰅐";
    keyColor= "green";
    }
    {
    type= "display";
    key= "│ └󰍹";
    keyColor= "green";
    }
    {
    type= "sound";
    key= " AUDIO";
    format= "{2}";
    keyColor= "magenta";
    }
    {
    type= "player";
    key= "│ ├󰥠";
    keyColor = "magenta";
    }
    {
    type= "media";
    key = "│ └󰝚";
    keyColor = "magenta";
    }
    {
    type = "custom";
   format = "{#90}  {#31}  {#32}  {#33}  {#34}  {#35}  {#36}  {#37}  {#38}  {#39}  {#39}    {#38}  {#37}  {#36}  {#35}  {#34}  {#33}  {#32}  {#31}  {#90}";}
    "break"
      ];
};
   };
   
   #Java Configiration
   java = {
    enable = true;
    package = pkgs.jdk;
  };

   #Zoxide cd replacement
   zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  };


  home.sessionVariables = {
    LIBVIRT_DEFAULT_URI="qemu:///system";
    EDITOR = "nano";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
    NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
    NIXOS_OZONE_WL = "1";
    ZSH_PATH = "${pkgs.zsh}/bin/zsh";
  };


#    systemd.user.services.bridgedNetworking = {
#     Unit = {
#       Description = "Bridged Networking for KVM machine using ipvtap.";
#     };
#     Install = {
#       WantedBy = [ "graphical.target" ];
#     };
#     Service = {
#       User = "root";
#       ExecStart = "/home/gamal/.dotfiles/Scripts/bridgedNetworking.sh";
#       Restart = "on-failure";
#     };
#   };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
