# nixos-config

To use this config:

```bash
git clone https://github.com/estromenko/nixos-config ~/nixos-config
sudo nixos-rebuild switch --flake ~/nixos-config

# Or reload home manager configs without sudo
nix-shell -p home-manager --run "home-manager switch --flake ~/nixos-config"
```

To modify this config:

```bash
cd ~/nixos-config
direnv allow
zeditor .
```
