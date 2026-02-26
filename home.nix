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

  home.file.".config/hypr/custom/keybinds.conf".source = ./hypr-custom/keybinds.conf;
  home.file.".config/hypr/custom/general.conf".source = ./hypr-custom/general.conf;
  home.file.".config/hypr/custom/execs.conf".source = ./hypr-custom/execs.conf;
  home.file.".config/hypr/custom/rules.conf".source = ./hypr-custom/rules.conf;
  home.file.".config/hypr/custom/env.conf".source = ./hypr-custom/env.conf;

  home.packages = with pkgs; [
    firefox
    spotify
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
