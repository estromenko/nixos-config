{
  pkgs,
  config,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home.enableNixpkgsReleaseCheck = false;

  home.username = "estromenko";
  home.homeDirectory = "/home/estromenko";

  home.packages = with pkgs; [
    xwayland-satellite
    (lib.hiPrio uutils-coreutils-noprefix)
    google-chrome
    telegram-desktop
    onlyoffice-bin
    cosmic-notifications
    cosmic-settings
    cosmic-applets
    cosmic-panel
    zellij
    bottom
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
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };

  services.wpaperd = {
    enable = true;
    settings.any = {
      path = ./assets/wallpaper.png;
    };
  };

  programs.niri.settings = import ./niri.nix {config = config;};

  programs.helix = import ./helix.nix {pkgs = pkgs;};

  programs.yazi = {
    enable = true;
    settings = {
      mgr = {
        show_hidden = true;
        show_symlink = true;
      };
    };
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
