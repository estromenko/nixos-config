{
  pkgs,
  inputs,
  ...
}:
let
  rustupForCargoCompletion = pkgs.runCommand "rustup-for-cargo-completion" { } ''
    mkdir -p "$out/bin"
    ln -s "${pkgs.rustup}/bin/rustup" "$out/bin/rustup"
  '';
in {
  nixpkgs.config.allowUnfree = true;

  home.enableNixpkgsReleaseCheck = false;

  home.username = "estromenko";
  home.homeDirectory = "/home/estromenko";

  manual.manpages.enable = false;

  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 32;
  };

  home.packages = with pkgs; [
    opentofu
    zarf
    grype
    gdu
    bun
    zellij
    papirus-icon-theme
    xwayland-satellite
    google-chrome
    telegram-desktop
    onlyoffice-desktopeditors
    bottom
    nerd-fonts.hack
    zrok
    k9s
    sops
    kubectl
    kubernetes-helm
    kubernetes-helmPlugins.helm-secrets
    helmfile
    kustomize
    openssl
    kind
    func
    k3d
    youki
    pocketbase
    pack
    skaffold
    podman
    podman-compose
    just
    ripgrep
    dig
    uv
    ruff
    ty
    nil
    nixd
    opencode
    obs-studio
    jq
    nodejs
    pnpm
    gcc
    cargo
    rustupForCargoCompletion
    gopls
    rust-analyzer
    tailwindcss_4
    prek
    rustfmt
    rustc
    clippy
    oha
    bacon
    cargo-tarpaulin
    tokei
    openssl
    tinymist
    typescript-language-server
    yaml-language-server
    go
    gopls
    gofumpt
    golangci-lint-langserver
    golangci-lint
    alsa-tools
    werf
    inputs.hermes-agent.packages.${stdenv.hostPlatform.system}.default
  ];

  fonts.fontconfig.enable = true;

  programs.jujutsu.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "estromenko@mail.ru";
        name = "estromenko";
      };
      core.excludesfile = "~/.gitignore";
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

  home.file.".config/niri/config.kdl".text = builtins.readFile ./niri-config.kdl;

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings.theme = "tokyonight";
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };

  programs.zoxide.enable = true;

  programs.alacritty = {
    package = pkgs.alacritty-graphics;
    enable = true;
    theme = "tokyo_night";
    settings.env.TERM = "xterm-256color";
  };

  programs.noctalia= {
    enable = true;
    settings.wallpaper = {
      enable = true;
      default.path = ./assets/wallpaper.png;
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
    env=TERMCMD="${pkgs.alacritty}/bin/alacritty -e"
    cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    default_dir=$HOME/Downloads
  '';

  home.stateVersion = "25.05";
}
