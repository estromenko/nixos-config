{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.power-profiles-daemon.enable = true;

  services.resolved.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  networking = {
    hostName = "estromenko";
    firewall.enable = true;
    nameservers = ["8.8.8.8" "1.1.1.1"];
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-l2tp
      ];
      dns = "systemd-resolved";
    };
  };

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

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      user = "greeter";
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

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
  documentation.man.generateCaches = false;

  # Fix for L2TP VPN connection
  environment.etc = {
    "strongswan.conf".text = "";
  };

  virtualisation.docker.enable = true;

  programs.niri.enable = true;
  programs.nix-ld.enable = true;
  programs.fish.enable = true;

  users.users.estromenko = {
    isNormalUser = true;
    description = "estromenko";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.fish;
  };

  home-manager.backupFileExtension = "backup";

  home-manager.extraSpecialArgs = {inherit inputs;};
  home-manager.users.estromenko = {...}: {
    imports = [
      ./home.nix
    ];
  };

  system.stateVersion = "25.05";
}
