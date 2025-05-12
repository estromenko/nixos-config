{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "estromenko";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  services.xserver.excludePackages = [ pkgs.xterm ];
  documentation.nixos.enable = false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    vim
    zellij
    google-chrome
    telegram-desktop
    fuzzel
    ripgrep
    neovim
    rio
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  virtualisation.docker.enable = true;

  programs.niri.enable = true;
  programs.waybar.enable = true;
  programs.amnezia-vpn.enable = true;
  programs.fish.enable = true;

  users.users.estromenko = {
    isNormalUser = true;
    description = "estromenko";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  home-manager.users.estromenko = { pkgs, ... }: {
    home.packages = with pkgs; [];
    services.mako.enable = true;
    programs.git = {
      enable = true;
      userEmail = "estromenko@mail.ru";
      userName = "estromenko";
      extraConfig.init.defaultBranch = "master";
    };

    home.stateVersion = "25.05";
  };

  system.stateVersion = "25.05";
}
