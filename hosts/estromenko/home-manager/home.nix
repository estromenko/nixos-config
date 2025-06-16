{
  pkgs,
  config,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home.enableNixpkgsReleaseCheck = false;

  home.username = "estromenko";
  home.homeDirectory = "/home/estromenko";

  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 32;
  };

  home.packages = with pkgs; [
    google-chrome
    telegram-desktop
    cosmic-applets
    cosmic-panel
    bottom
  ];

  services.swaync.enable = true;

  programs.zellij = {
    enable = true;
    settings = {
      show_startup_tips = false;
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

  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = inputs.helix.packages.${pkgs.system}.default;
    settings.theme = "tokyonight";
    extraPackages = with pkgs; [
      nil
      nixd
      cargo
      rust-analyzer
      ruff
      pyright
      tinymist
    ];
    languages.language = [
      {
        name = "python";
        language-servers = ["pyright" "ruff"];
      }
    ];
  };

  programs.yazi.enable = true;

  programs.zoxide.enable = true;

  programs.rio = {
    enable = true;
    settings = {
      env-vars = ["TERM=xterm-256color"];
      confirm-before-quit = false;
    };
  };

  xdg.portal = {
    enable = true;
    config.common = {
      default = ["gnome"];
      "org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-termfilechooser
    ];
  };

  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    env=TERMCMD="rio -e"
    cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    default_dir=$HOME/Downloads
  '';

  home.stateVersion = "25.05";
}
