{ config, pkgs, lib, ... }:
{
  home.username = "nick";
  home.homeDirectory = "/home/nick";
  programs.illogical-impulse = {
    enable = true;
    dotfiles = {
      fish.enable = true;
      kitty.enable = true;
      starship.enable = true;
    };
  };
  xdg.configFile."hypr/hypridle.conf" = lib.mkForce {
    text = ''
      general {
          after_sleep_cmd = hyprctl dispatch dpms on
      }
      listener {
          timeout = 600
          on-timeout = hyprctl dispatch dpms off
          on-resume = hyprctl dispatch dpms on && sleep 1 && hyprctl reload
      }
    '';
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_vi_key_bindings
      set fish_cursor_default block
      set fish_cursor_insert line
      set fish_cursor_replace_one underscore
      set fish_cursor_visual block
    '';
  };
  programs.fish.shellAliases = {
    ll = "ls -la";
    gs = "git status";
    rebuild = "sudo nixos-rebuild switch --flake .#";
    nixos = "cd /etc/nixos";
  };
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
  };
  home.file.".config/illogical-impulse/config.json".source = ./illogical-impulse-config.json;
  home.packages = with pkgs; [
    firefox
    spotify
    playerctl
  ];
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
