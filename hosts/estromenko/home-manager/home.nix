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
    networkmanagerapplet
    pavucontrol
    swaynotificationcenter
    cosmic-files
    cosmic-settings
    vim
    zellij
    google-chrome
    telegram-desktop
    onlyoffice-bin
    fuzzel
    rio
  ];

  home.file.".config/rio/config.toml".source = ./assets/rio-config.toml;

  programs.zed-editor = {
    enable = true;
    extensions = ["nix" "python" "dockerfile" "yaml" "toml" "git-firefly"];
    userSettings = {
      vim_mode = true;
      telemetry = {
        metrics = false;
      };
      theme = "One Dark";
    };
  };
  programs.git = {
    enable = true;
    userEmail = "estromenko@mail.ru";
    userName = "estromenko";
    extraConfig.init.defaultBranch = "master";
  };
  programs.ironbar = {
    enable = true;
    systemd = true;
    config = import ./ironbar.nix;
    style = builtins.readFile ./assets/ironbar.css;
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
    enableFishIntegration = true;
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableFishIntegration = true;
  };

  services.wpaperd = {
    enable = true;
    settings.any = {
      path = ./assets/wallpaper.png;
    };
  };
  programs.niri.settings = import ./niri.nix {config = config;};
  home.stateVersion = "25.05";
}
