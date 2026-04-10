{ config, pkgs, lib, ... }:
{
  home.username    = "nick";
  home.homeDirectory = "/home/nick";

  # ---------------------------------------------------------------------------
  # Fish shell
  # ---------------------------------------------------------------------------
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_vi_key_bindings
      set fish_cursor_default     block
      set fish_cursor_insert      line
      set fish_cursor_replace_one underscore
      set fish_cursor_visual      block
    '';
    shellAliases = {
      ll      = "ls -la";
      gs      = "git status";
      rebuild = "sudo nixos-rebuild switch --flake .#";
      nixos   = "cd /etc/nixos";
    };
  };

  # ---------------------------------------------------------------------------
  # Atuin — shell history sync
  # ---------------------------------------------------------------------------
  programs.atuin = {
    enable               = true;
    enableFishIntegration = true;
  };

  # ---------------------------------------------------------------------------
  # Kitty terminal
  # ---------------------------------------------------------------------------
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell       = false;
    };
  };

  # ---------------------------------------------------------------------------
  # Starship prompt
  # ---------------------------------------------------------------------------
  programs.starship = {
    enable               = true;
    enableFishIntegration = true;
  };

  # ---------------------------------------------------------------------------
  # Niri — config.kdl lives in the repo, symlinked into place
  # Drop your config at /etc/nixos/niri-config.kdl
  # ---------------------------------------------------------------------------
  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;

  # ---------------------------------------------------------------------------
  # Waybar
  # ---------------------------------------------------------------------------
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 38;
      margin-top = 6;
      margin-left = 8;
      margin-right = 8;
      modules-left   = [ "niri/workspaces" ];
      modules-center = [ "niri/window" ];
      modules-right  = [ "pulseaudio" "network" "cpu" "memory" "clock" "tray" ];

      "niri/workspaces" = {
        on-click = "activate";
      };
      "clock" = {
        format = "{:%a %b %d  %H:%M}";
      };
      "cpu" = {
        format = " {usage}%";
        interval = 5;
      };
      "memory" = {
        format = " {}%";
        interval = 5;
      };
      "network" = {
        format-wifi = " {essid}";
        format-ethernet = " {ipaddr}";
        format-disconnected = "⚠ Disconnected";
      };
      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-muted = " muted";
        format-icons = { default = [ "" "" "" ]; };
        on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
      "tray" = {
        spacing = 8;
      };
    }];

  style = ''
    * {
      font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
      font-size: 13px;
      border: none;
      border-radius: 0;
      min-height: 0;
    }

    /* Transparent window so the bar "floats" */
    window#waybar {
      background: transparent;
      color: #cdd6f4;
    }

    /* The actual bar surface — dark, slightly transparent, floating with margin */
    .modules-left,
    .modules-center,
    .modules-right {
      background: rgba(17, 17, 27, 0.85);
      border-radius: 12px;
      margin: 6px 4px;
      padding: 0 4px;
    }

    /* Each module gets subtle padding */
    #workspaces,
    #clock,
    #cpu,
    #memory,
    #network,
    #pulseaudio,
    #tray,
    #window {
      padding: 2px 10px;
      color: #cdd6f4;
    }

    /* Pill background on individual right-side modules */
    #clock,
    #cpu,
    #memory,
    #network,
    #pulseaudio {
      background: rgba(30, 30, 46, 0.9);
      border-radius: 8px;
      margin: 4px 2px;
      padding: 2px 12px;
    }

    /* Workspace buttons */
    #workspaces button {
      padding: 2px 10px;
      color: #6c7086;
      background: transparent;
      border-radius: 8px;
      margin: 4px 1px;
    }

    #workspaces button.active {
      color: #1e1e2e;
      background: #89b4fa;
      font-weight: bold;
    }

    #workspaces button:hover {
      background: rgba(137, 180, 250, 0.2);
      color: #cdd6f4;
    }

    /* Module accent colors */
    #clock     { color: #89b4fa; }
    #cpu       { color: #a6e3a1; }
    #memory    { color: #f38ba8; }
    #pulseaudio { color: #f9e2af; }
    #network   { color: #94e2d5; }
    #tray      { padding: 2px 8px; }
  '';
 };

  # ---------------------------------------------------------------------------
  # Fuzzel — app launcher (niri default: Super+D)
  # ---------------------------------------------------------------------------
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal       = "${pkgs.kitty}/bin/kitty";
        font           = "JetBrainsMono Nerd Font:size=12";
        icon-theme     = "hicolor";
        prompt         = "\"  \"";
      };
    };
  };

  # ---------------------------------------------------------------------------
  # Mako — Wayland notification daemon
  # ---------------------------------------------------------------------------
  services.mako = {
    enable          = true;
    defaultTimeout  = 5000;
    font            = "JetBrainsMono Nerd Font 11";
  };

  # ---------------------------------------------------------------------------
  # Swaylock — screen locker (niri default: Super+Alt+L)
  # ---------------------------------------------------------------------------
  programs.swaylock = {
    enable   = true;
    settings = {
      color        = "000000";
      show-failed-attempts = true;
    };
  };

  # ---------------------------------------------------------------------------
  # Swayidle — idle management (dim/lock/sleep)
  # ---------------------------------------------------------------------------
  services.swayidle = {
    enable    = true;
    timeouts  = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      { timeout = 600; command = "niri msg action power-off-monitors"; }
    ];
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      { event = "lock";         command = "${pkgs.swaylock}/bin/swaylock -f"; }
    ];
  };

  # ---------------------------------------------------------------------------
  # Home packages
  # ---------------------------------------------------------------------------
  home.packages = with pkgs; [
    firefox
    spotify
    playerctl
    swaybg              # wallpaper setter
    xwayland-satellite  # XWayland support for legacy apps under niri
    pavucontrol
  ];

  # ---------------------------------------------------------------------------
  home.stateVersion        = "24.11";
  programs.home-manager.enable = true;
  programs.yazi.enable = true;
}
