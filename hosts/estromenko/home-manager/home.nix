{
  pkgs,
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
    onlyoffice-desktopeditors
    cosmic-applets
    cosmic-panel
    bottom
    nerd-fonts.hack
    comma
    zrok
    k9s
    kubectl
    kubectl-cnpg
    kubernetes-helm
    kind
    fluxcd
    cilium-cli
    dig
    nftables
    sops
    age
    talosctl
    talhelper
    k0sctl
    uv
    ruff
    ty
    nil
    nixd
    qwen-code
    gcc
    cargo
    gopls
    rust-analyzer
    tinymist
    typescript-language-server
    yaml-language-server
    go
    gopls
    gofumpt
    golangci-lint-langserver
    golangci-lint
  ];

  fonts.fontconfig.enable = true;

  services.swaync.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "estromenko@mail.ru";
        name = "estromenko";
      };
      init.defaultBranch = "master";
    };
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

  home.file.".config/niri/config.kdl".text = builtins.readFile ./niri-config.kdl;

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings.theme = "tokyonight";
  };

  programs.yazi.enable = true;

  programs.zoxide.enable = true;

  programs.alacritty = {
    package = pkgs.alacritty-graphics;
    enable = true;
    theme = "tokyo_night";
    settings.env.TERM = "xterm-256color";
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
    env=TERMCMD="${pkgs.alacritty}/bin/alacritty -e"
    cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    default_dir=$HOME/Downloads
  '';

  home.stateVersion = "25.05";
}
