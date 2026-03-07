# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = false; # optional
  services.xserver.desktopManager.xterm.enable = false;  # optional
  programs.xwayland.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.autoLogin.enable = false;


  # Add this section for Discord environment variables
  environment.sessionVariables = {
    # Force Discord to use GPU
    NIXOS_OZONE_WL = "1";  # Enable Wayland for Electron apps
  };

  # Set Hyprland as default
  # services.displayManager.defaultSession = "hyprland";
  # programs.hyprland.enable = true;
  
  # Use home-manager or system-wide dconf
  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/desktop/screensaver" = {
        lock-enabled = false;
      };
      "org/gnome/desktop/session" = {
        idle-delay = lib.gvariant.mkUint32 0;  # <-- Fixed!
      };
    };
  }];
  home-manager.backupFileExtension = "bak";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nick = {
    isNormalUser = true;
    description = "Nick Testa";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #  thunderbird
	    (discord.override {
        withOpenASAR = true;  # Better performance
        withVencord = false;   # Optional: adds plugins/themes
      })
    	spotify
    	helix
  	  # Language servers for different languages:
      rust-analyzer      # Rust
      nil                # Nix
      nixd              # Alternative Nix LSP
      nodePackages.typescript-language-server  # TypeScript/JavaScript
      pyright           # Python
      lua-language-server  # Lua
      gopls             # Go
    	git
    	wget
    	curl
    	podman
    	bitwarden-desktop
    	atuin
    	starship
    	steam
    	liquidctl
    	onlyoffice-desktopeditors
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.fish.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  # Waybar
  programs.waybar = {
    enable = true;
  };

  services.geoclue2.enable = true;
  
  fonts.packages = with pkgs; [
    rubik
    nerd-fonts.ubuntu
    nerd-fonts.jetbrains-mono
  ];
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	  kitty
	  wl-clipboard
	  wofi
    playerctl      # for media controls
    brightnessctl  # for brightness (laptops)
    waybar
    bibata-cursors  # or adwaita-icon-theme 
  ];

  users.users.nick.shell = pkgs.fish;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Use stable LTS kernel (6.6.x) instead of latest (6.19)
  boot.kernelPackages = pkgs.linuxPackages;

  # Enable OpenGL
  hardware.graphics.enable = true;

  # Load NVIDIA driver
  services.xserver.videoDrivers = ["nvidia"];

  # NVIDIA settings
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

 # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
