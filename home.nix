{ config, pkgs, ... }:

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
  home.file.".config/illogical-impulse/config.json".source = ./illogical-impulse-config.json;

  home.packages = with pkgs; [
    firefox
    spotify
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
