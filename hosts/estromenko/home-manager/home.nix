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
    extraPackages = with pkgs; [
      cargo
    ];
    settings = {
      keys.normal.space.e = "file_picker_in_current_buffer_directory";
      theme = "tokyonight";
    };
    languages = {
      language = [
        {
          name = "rust";
          language-servers = ["rust-analyzer"];
          file-types = ["rs"];
          auto-format = true;
          formatter = {
            command = "${pkgs.rustfmt}/bin/rustfmt";
          };
        }
        {
          name = "python";
          language-servers = ["ty" "pyright"];
          file-types = ["py"];
          roots = ["pyproject.toml" "setup.py" "Poetry.lock" ".git" ".venv"];
          comment-token = "#";
          shebangs = ["python" "python3"];
        }
      ];
      language-server = {
        rust-analyzer = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          checkOnSave.command = "${pkgs.clippy}/bin/clippy";
          procMacro.enable = true;
        };
        ty = {
          command = "${pkgs.ty}/bin/ty";
          args = ["server"];
          experimental.completions.enable = true;
        };
        pyright = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
        };
      };
    };
  };

  programs.yazi = {
    enable = true;
    settings = {
      manager = {
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
