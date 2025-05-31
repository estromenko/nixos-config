{pkgs, ...}: {
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
}
