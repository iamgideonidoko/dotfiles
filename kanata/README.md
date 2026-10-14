# Kanata

Linux Hyper-key layers matching Karabiner. Edit [config.ts](./config.ts); it generates `kanata.kbd`.
Run these commands from the repo root:

```sh
make kanata-setup   # Build, install, link, and enable
make kanata         # Rebuild config
make kanata-restart # Rebuild and restart
```

Tap Caps Lock for Caps Lock; hold it for Hyper. Hold a layer key, or tap it and
press the action key within two seconds:

| Layer | Actions           |
| ----- | ----------------- |
| O     | Launch/focus apps |
| B     | Browser shortcuts |
| E     | Mouse control     |
| W     | Tabs and windows  |
| S     | System controls   |
| V     | Vim navigation    |
| C     | Media controls    |

`W + N/P` cycles windows of the same Hyprland class across workspaces.
Apps and webapps with different classes stay separate; see `config.ts` for app mappings.

Some keyboards drop three-key chords. If `Caps Lock + S + K` fails, hold Caps Lock,
tap and release S, then press K. Kanata cannot handle key events the keyboard drops.

Setup grants `input`/`uinput` group access. Any process running as your user can then
read keyboard events. Log out and back in if setup requests it.
