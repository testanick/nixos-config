# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  # ---------------------------------------------------------------------------
  # COSMIC Desktop Environment
  # ---------------------------------------------------------------------------
  # cosmic-comp is a Wayland compositor, so X11 server is not needed for the
  # DE itself — but we keep xwayland for apps that require it.
  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;

  # XWayland for legacy X11 app compat
  programs.xwayland.enable = true;

  # Disable the old GNOME/GDM stack we're replacing
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

  # Clipboard support inside COSMIC (requires zwlr_data_control_manager_v1)
  # environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  # Flatpak support — lets you use COSMIC Store for Flatpak apps later.
  # After rebuild, run:
  #   flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # services.flatpak.enable = true;

  programs.niri.enable = true;
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.niri}/bin/niri-session";
      user = "nick";
    };
  };
  # Recommended companions:
  # programs.waybar.enable = true;
  services.gnome.gnome-keyring.enable = true;  # for credential storage
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];

  # dconf still useful for some GTK settings
  programs.dconf.enable = true;

  # ---------------------------------------------------------------------------
  # Configure keymap
  # ---------------------------------------------------------------------------
  services.xserver.xkb = {
    layout  = "us";
    variant = "";
  };

  # ---------------------------------------------------------------------------
  # Printing
  # ---------------------------------------------------------------------------
  services.printing.enable = true;

  # ---------------------------------------------------------------------------
  # Audio — pipewire
  # ---------------------------------------------------------------------------
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable          = true;
    alsa.enable     = true;
    alsa.support32Bit = true;
    pulse.enable    = true;
  };

  # ---------------------------------------------------------------------------
  # User
  # ---------------------------------------------------------------------------
  users.users.nick = {
    isNormalUser = true;
    description  = "Nick Testa";
    extraGroups  = [ "networkmanager" "wheel" ];
    shell        = pkgs.fish;
    packages     = with pkgs; [
      spotify
      helix

      # Language servers
      rust-analyzer
      nil
      nixd
      typescript-language-server
      pyright
      lua-language-server
      gopls

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
      vesktop
      claude-code
      pavucontrol
      thunar
      yazi
    ];
  };

  # ---------------------------------------------------------------------------
  # Shell & base programs
  # ---------------------------------------------------------------------------
  programs.firefox.enable = true;
  programs.fish.enable    = true;

  # ---------------------------------------------------------------------------
  # Nix settings
  # ---------------------------------------------------------------------------
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "nick" ];
  };

  # ---------------------------------------------------------------------------
  # Kernel — stable LTS
  # ---------------------------------------------------------------------------
  boot.kernelPackages = pkgs.linuxPackages;

  # ---------------------------------------------------------------------------
  # NVIDIA
  # ---------------------------------------------------------------------------
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable          = true;
    powerManagement.enable      = true;
    powerManagement.finegrained = false;
    open                        = false;
    nvidiaSettings              = true;
    package                     = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  # ---------------------------------------------------------------------------
  # Fonts
  # ---------------------------------------------------------------------------
  fonts.packages = with pkgs; [
    rubik
    nerd-fonts.ubuntu
    nerd-fonts.jetbrains-mono
  ];

  # ---------------------------------------------------------------------------
  # System packages
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    kitty
    wl-clipboard
    playerctl
    brightnessctl
    fuzzel        # app launcher (Super+D by default)
    swaylock      # screen locker (Super+Alt+L by default)  
    mako          # notifications
    swaybg        # wallpaper
    xwayland-satellite  # XWayland support for legacy apps
  ];

  # ---------------------------------------------------------------------------
  home-manager.backupFileExtension = "bak";

  system.stateVersion = "25.11";
}
