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
    google-chrome
    telegram-desktop
    nautilus
    cosmic-applets
    cosmic-panel
    bottom
  ];

  services.swaync.enable = true;

  programs.zellij = {
    enable = true;
    attachExistingSession = true;
    enableFishIntegration = true;
    exitShellOnExit = true;
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
      set fish_vi_key_bindings
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
      env-vars = ["TERM=xterm-256color"];
      confirm-before-quit = false;
    };
  };

  home.stateVersion = "25.05";
}
