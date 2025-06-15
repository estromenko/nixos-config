{
  pkgs,
  inputs,
  ...
}: {
  enable = true;
  package = inputs.helix.packages.${pkgs.system}.default;
  defaultEditor = true;
  extraPackages = with pkgs; [
    cargo
  ];
  settings = {
    keys.normal = {
      C-y = [
        ":sh rm -f /tmp/unique-file"
        ":insert-output yazi \"%{buffer_name}\" --chooser-file=/tmp/unique-file"
        ":insert-output echo \"\x1b[?1049h\x1b[?2004h\" > /dev/tty"
        ":open %sh{cat /tmp/unique-file}"
        ":cd %sh{cat /tmp/unique-file | xargs dirname}"
        ":redraw"
        ":set mouse false"
        ":set mouse true"
      ];
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
