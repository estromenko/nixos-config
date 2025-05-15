{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.default];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.gvfs.enable = true;

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

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
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

  services.xserver.excludePackages = [pkgs.xterm];
  documentation.nixos.enable = false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  fonts.packages = with pkgs; [nerd-fonts.hack];

  virtualisation.docker.enable = true;

  programs.niri.enable = true;
  programs.amnezia-vpn.enable = true;
  programs.nix-ld.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      starship init fish | source
    '';
  };

  users.users.estromenko = {
    isNormalUser = true;
    description = "estromenko";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = [];
    shell = pkgs.fish;
  };

  home-manager.backupFileExtension = "backup";

  home-manager.users.estromenko = {pkgs, ...}: {
    imports = [
      inputs.ironbar.homeManagerModules.default
    ];
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      networkmanagerapplet
      pavucontrol
      pcmanfm
      vim
      zellij
      google-chrome
      telegram-desktop
      onlyoffice-bin
      fuzzel
      rio
      nodejs
      nixd
      nil
    ];
    services.mako.enable = true;

    home.file.".config/rio/config.toml".text = ''
      [window]
      mode = "maximized"
      opacity = 0.9
    '';

    home.file.".config/niri/config.kdl".source = ./niri.kdl;

    programs.zed-editor = {
      enable = true;
      extensions = ["nix" "python" "dockerfile" "yaml" "toml"];
      userSettings = {
        vim_mode = true;
        telemetry = {
          metrics = false;
        };
        theme = "One Dark";
      };
    };
    programs.git = {
      enable = true;
      userEmail = "estromenko@mail.ru";
      userName = "estromenko";
      extraConfig.init.defaultBranch = "master";
    };
    programs.ironbar = {
      enable = true;
      systemd = true;
    };
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
      };
      enableFishIntegration = true;
    };
    home.stateVersion = "25.05";
  };

  system.stateVersion = "25.05";
}
