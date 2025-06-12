{pkgs, ...}: {
  enable = true;
  package = pkgs.evil-helix;
  defaultEditor = true;
  extraPackages = with pkgs; [
    cargo
  ];
  settings = {
    keys.normal = {
      space.e = "@:cd <C-r>%<C-w><ret>";
      V = ["extend_line_below" "select_mode"];
    };
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
        language-servers = ["ty" "ruff" "pyright"];
        file-types = ["py"];
        roots = ["pyproject.toml" "setup.py" "Poetry.lock" ".git" ".venv"];
        comment-token = "#";
        shebangs = ["python" "python3"];
      }
      {
        name = "nix";
        language-servers = ["nil" "nixd"];
        file-types = ["nix"];
      }
      {
        name = "typst";
        language-servers = ["tinymist"];
        file-types = ["typ"];
        comment-token = "//";
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
      ruff = {
        command = "${pkgs.ruff}/bin/ruff";
        args = ["server"];
      };
      nil = {
        command = "${pkgs.nil}/bin/nil";
      };
      nixd = {
        command = "${pkgs.nixd}/bin/nixd";
      };
      tinymist = {
        command = "${pkgs.tinymist}/bin/tinymist";
      };
    };
  };
}
