{ config, inputs, pkgs, nixgl, ... }:


let

in
{

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "gamal";
  home.homeDirectory = "/home/gamal";
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
  home.file.".var/app/com.google.Chrome/config/chrome-flags.conf".text = ''--ozone-platform-hint=auto
--enable-features=TouchpadOverscrollHistoryNavigation,VaapiVideoDecoder,VaapiVideoEncoder'';
  # The home.packages option allows you to install Nix packages into your
  # environment.
  fonts.fontconfig.enable = true;
  home.packages = with pkgs;[
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.nixgl.nixGLIntel
    pkgs.nixgl.nixVulkanIntel
    (config.lib.nixGL.wrap vscode)
    (config.lib.nixGL.wrap github-desktop)
    (config.lib.nixGL.wrap codeblocks)
    (config.lib.nixGL.wrap netbeans)
    (config.lib.nixGL.wrap zed-editor)
    ruby
    go
#     android-tools
    #(config.lib.nixGL.wrap android-studio)
    (config.lib.nixGL.wrap (jetbrains.plugins.addPlugins jetbrains.idea-ultimate ["github-copilot"]))
    (config.lib.nixGL.wrap (jetbrains.plugins.addPlugins jetbrains.rust-rover ["github-copilot"]))
    (config.lib.nixGL.wrap (jetbrains.plugins.addPlugins jetbrains.rider ["github-copilot"]))
    (config.lib.nixGL.wrap (jetbrains.plugins.addPlugins jetbrains.pycharm-professional ["github-copilot"]))
    (config.lib.nixGL.wrap (jetbrains.plugins.addPlugins jetbrains.clion ["github-copilot"]))
    git-credential-manager
    neovim
    nodejs
    megasync
    emacs-gtk
    glxinfo
    vistafonts
    corefonts
    fira-code
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode"]; })
    (config.lib.nixGL.wrap (brave.override{
         commandLineArgs = ["--ozone-platform-hint=wayland""--enable-features=TouchpadOverscrollHistoryNavigation,VaapiVideoDecoder,VaapiVideoEncoder""--no-default-browser-check"];
     }))

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
    zsh ={
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
  };
   initExtra = ''
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
         #font_family = "Fira Code SemiBold";
         font_size = 16;
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
    EDITOR = "nano";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
    NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
