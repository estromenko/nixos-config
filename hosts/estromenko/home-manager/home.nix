{
  pkgs,
  config,
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
    xwayland-satellite
    google-chrome
    telegram-desktop
    onlyoffice-bin
    cosmic-applets
    cosmic-panel
    bottom
    nerd-fonts.hack
    comma
  ];

  fonts.fontconfig.enable = true;

  services.swaync.enable = true;

  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
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

  programs.niri = {
    package = pkgs.niri_git;
    settings = import ./niri.nix {config = config;};
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = pkgs.helix_git;
    settings.theme = "tokyonight";
    extraPackages = with pkgs; [
      gcc
      nil
      nixd
      cargo
      rust-analyzer
      ruff
      pyright
      ty
      tinymist
      typescript-language-server
    ];
    languages.language = [
      {
        name = "python";
        language-servers = ["pyright" "ruff" "ty"];
      }
    ];
  };

  programs.yazi.enable = true;

  programs.zoxide.enable = true;

  programs.alacritty = {
    package = pkgs.alacritty-graphics;
    enable = true;
    theme = "tokyo_night";
  };

  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor_git;
    extensions = ["nix" "python" "dockerfile" "yaml" "toml" "git-firefly"];
    userSettings = {
      vim_mode = true;
      telemetry = {
        metrics = false;
      };
      theme = "One Dark";
      format_on_save = "off";
      remove_trailing_whitespace_on_save = false;
      ensure_final_newline_on_save = false;
      features = {
        edit_prediction_provider = "none";
      };
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
