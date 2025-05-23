{
  pkgs,
  config,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home.enableNixpkgsReleaseCheck = false;

  home.username = "estromenko";
  home.homeDirectory = "/home/estromenko";

  home.sessionVariables = {
    EDITOR = "vim";
    TERM = "xterm-256color";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  home.packages = with pkgs; [
    xwayland-satellite
    (lib.hiPrio uutils-coreutils-noprefix)
    networkmanagerapplet
    vim
    zellij
    google-chrome
    telegram-desktop
    onlyoffice-bin
  ];

  programs.zed-editor = {
    enable = true;
    extensions = ["nix" "python" "dockerfile" "yaml" "toml" "git-firefly"];
    userSettings = {
      vim_mode = true;
      telemetry = {
        metrics = false;
      };
      theme = "One Dark";
      format_on_save = "off";
    };
  };
  programs.git = {
    enable = true;
    userEmail = "estromenko@mail.ru";
    userName = "estromenko";
    extraConfig.init.defaultBranch = "master";
  };
  programs.fish.enable = true;
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.wpaperd = {
    enable = true;
    settings.any = {
      path = ./assets/wallpaper.png;
    };
  };
  programs.niri.settings = import ./niri.nix {config = config;};

  systemd.user.services.cosmic-panel = {
    Install.WantedBy = ["default.target"];
    Service = {
      ExecStart = "${pkgs.cosmic-panel}/bin/cosmic-panel";
      ExecStop = "kill cosmic-panel";
      Restart = "always";
      RestartSec = 1;
    };
  };

  systemd.user.services.cosmic-notifications = {
    Install.WantedBy = ["default.target"];
    Service = {
      ExecStart = "${pkgs.cosmic-notifications}/bin/cosmic-notifications";
      ExecStop = "kill cosmic-notifications";
      Restart = "always";
      RestartSec = 1;
    };
  };

  home.stateVersion = "25.05";
}
