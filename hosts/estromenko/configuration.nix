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

  services.desktopManager.cosmic = {
    enable = true;
    xwayland.enable = false;
  };
  services.displayManager.cosmic-greeter.enable = true;
  services.displayManager.sessionPackages = [
    ((pkgs.writeTextFile {
      name = "cosmic-niri";
      destination = "/share/wayland-sessions/cosmic-niri.desktop";
      text = ''
        [Desktop Entry]
        Name=Cosmic Niri
        Exec=cosmic-session niri-session
        Type=Application
        DesktopNames=cosmic-niri
      '';
    }).overrideAttrs (old: {passthru.providedSessions = ["cosmic-niri"];}))
  ];

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

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    (lib.hiPrio uutils-coreutils-noprefix)
  ];

  # Fix for L2TP VPN connection
  environment.etc = {
    "strongswan.conf".text = "";
  };

  fonts.packages = with pkgs; [nerd-fonts.hack];

  virtualisation.docker.enable = true;

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  programs.amnezia-vpn.enable = true;
  programs.nix-ld.enable = true;

  users.users.estromenko = {
    isNormalUser = true;
    description = "estromenko";
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  home-manager.backupFileExtension = "backup";

  home-manager.users.estromenko = {...}: {
    imports = [
      inputs.niri.homeModules.niri
      ./home-manager/home.nix
    ];
  };

  networking.firewall.enable = true;

  system.stateVersion = "25.05";
}
