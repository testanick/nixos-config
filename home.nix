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

  home.packages = with pkgs; [
    firefox
    spotify
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
