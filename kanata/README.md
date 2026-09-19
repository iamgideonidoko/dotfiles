# Kanata

TypeScript source generates `kanata.kbd`, matching the Karabiner Hyper-key layout.

```sh
make kanata
```

Caps Lock taps as Caps Lock. Hold Caps Lock for Hyper, then hold a layer key:

- `O`: launch or focus apps through Omarchy
- `B`: browser shortcuts
- `E`: mouse control
- `W`: tabs and windows
- `S`: system controls
- `V`: Vim navigation
- `C`: media controls

`kanata/setup.sh` grants raw keyboard access through the `input` group, as required by Kanata's official Linux setup. Any process running as this user can then read keyboard events.
