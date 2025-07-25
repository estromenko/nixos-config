{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
  };

  nixpkgs.overlays = [inputs.niri.overlays.niri];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.earlyoom.enable = true;

  services.gvfs.enable = true;

  services.thermald = {
    enable = true;
    ignoreCpuidCheck = true;
  };
  services.tlp.enable = true;

  networking.hostName = "estromenko";
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-l2tp
    ];
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
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
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

  services.upower.enable = true;

  # Fix for L2TP VPN connection
  environment.etc = {
    "strongswan.conf".text = "";
  };

  virtualisation.docker.enable = true;

  programs.niri = {
    enable = true;
    package = pkgs.niri_git;
  };
  programs.amnezia-vpn.enable = true;
  programs.nix-ld.enable = true;
  programs.fish.enable = true;

  users.users.estromenko = {
    isNormalUser = true;
    description = "estromenko";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.fish;
  };

  # niri-flake adds it on nixos level,
  # but I wish to configure it on home-manager level
  xdg.portal.enable = false;

  home-manager.backupFileExtension = "backup";

  home-manager.extraSpecialArgs = {inherit inputs;};
  home-manager.users.estromenko = {...}: {
    imports = [
      inputs.niri.homeModules.niri
      inputs.chaotic.homeManagerModules.default
      ./home-manager/home.nix
    ];
  };

  networking.firewall.enable = true;

  system.stateVersion = "25.05";
}
