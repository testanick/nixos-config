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

  home.file.".config/illogical-impulse/config.json".source = ./illogical-impulse-config.json;

  home.packages = with pkgs; [
    firefox
    spotify
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
