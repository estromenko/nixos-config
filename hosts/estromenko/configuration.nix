{
  pkgs,
  inputs,
  specialArgs,
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

  services.desktopManager.cosmic.enable = true;
  services.displayManager.sessionPackages = [
    ((
        pkgs.writeTextFile {
          name = "cosmic-on-niri";
          destination = "/share/wayland-sessions/COSMIC-on-niri.desktop";
          text = ''
            [Desktop Entry]
            Name=COSMIC-on-niri
            Comment=This session logs you into the COSMIC desktop on niri
            Type=Application
            DesktopNames=niri
            Exec=${pkgs.writeShellApplication {
              name = "start-cosmic-ext-niri";
              runtimeInputs = [pkgs.systemd pkgs.dbus specialArgs.inputs.cosmic-session.packages.x86_64-linux.default pkgs.bash pkgs.coreutils];
              text = ''
                set -e
                # From: https://people.debian.org/~mpitt/systemd.conf-2016-graphical-session.pdf
                if command -v systemctl >/dev/null; then
                    # robustness: if the previous graphical session left some failed units,
                    # reset them so that they don't break this startup
                    for unit in $(systemctl --user --no-legend --state=failed --plain list-units | cut -f1 -d' '); do
                        partof="$(systemctl --user show -p PartOf --value "$unit")"
                        for target in cosmic-session.target graphical-session.target; do
                            if [ "$partof" = "$target" ]; then
                                systemctl --user reset-failed "$unit"
                                break
                            fi
                        done
                    done
                fi
                # use the user's preferred shell to acquire environment variables
                # see: https://github.com/pop-os/cosmic-session/issues/23
                if [ -n "''${SHELL:-}" ]; then
                    # --in-login-shell: our flag to indicate that we don't need to recurse any further
                    if [ "''${1:-}" != "--in-login-shell" ]; then
                        # `exec -l`: like `login`, prefixes $SHELL with a hyphen to start a login shell
                        exec bash -c "exec -l ${"'"}''${SHELL}' -c ${"'"}''${0} --in-login-shell'"
                    fi
                fi
                export XDG_CURRENT_DESKTOP="''${XDG_CURRENT_DESKTOP:=niri}"
                export XDG_SESSION_TYPE="''${XDG_SESSION_TYPE:=wayland}"
                export XCURSOR_THEME="''${XCURSOR_THEME:=Cosmic}"
                export _JAVA_AWT_WM_NONREPARENTING=1
                export GDK_BACKEND=wayland,x11
                export MOZ_ENABLE_WAYLAND=1
                export QT_QPA_PLATFORM="wayland;xcb"
                export QT_AUTO_SCREEN_SCALE_FACTOR=1
                export QT_ENABLE_HIGHDPI_SCALING=1
                if command -v systemctl >/dev/null; then
                    # set environment variables for new units started by user service manager
                    systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
                fi
                # Run cosmic-session
                if [[ -z "''${DBUS_SESSION_BUS_ADDRESS}" ]]; then
                    exec dbus-run-session -- cosmic-session niri
                else
                    exec cosmic-session niri
                fi
              '';
            }}/bin/start-cosmic-ext-niri
          '';
        }
      ).overrideAttrs
      (old: {
        passthru.providedSessions = ["COSMIC-on-niri"];
      }))
  ];

  services.displayManager.cosmic-greeter.enable = true;

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

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    xwayland-satellite
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
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      export TERM=xterm-256color
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

  home-manager.users.estromenko = {...}: {
    imports = [
      inputs.niri.homeModules.niri
      ./home-manager/home.nix
    ];
  };

  networking.firewall.enable = true;

  system.stateVersion = "25.05";
}
