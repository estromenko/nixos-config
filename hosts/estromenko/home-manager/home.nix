{
  pkgs,
  config,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home.enableNixpkgsReleaseCheck = false;

  home.username = "estromenko";
  home.homeDirectory = "/home/estromenko";

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
    google-chrome
    telegram-desktop
    onlyoffice-bin
    cosmic-notifications
    cosmic-settings
    cosmic-applets
    cosmic-panel
    zellij
    fuzzel
    bottom
    yazi
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

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings.theme = "gruvbox";
  };

  programs.zoxide.enable = true;

  programs.rio = {
    enable = true;
    settings = {
      window.decorations = "Disabled";
      env-vars = ["TERM=xterm-256color"];
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-cosmic
      xdg-desktop-portal-gtk
    ];
  };

  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
  };

  home.stateVersion = "25.05";
}
