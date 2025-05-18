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

## Sound-related issues

Use hdajackretask and configure proper input/output devices in GUI, for instance:

```bash
nix-shell -p alsa-tools --run hdajackretask
```

## L2TP-related issues

For some reason creating empty strongswan config solves multiple l2tp problems.

```bash
sudo touch /etc/strongswan.conf
```
