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

In the `O` layer, `S` opens the Spotify desktop app and `K` opens the Slack
desktop app. `H` opens Notion, `M` YouTube Music, and `E` Photopea through the
launchers installed from `omarchy/webapps.jsonc`.
`D` opens a dictionary search, and `Y` opens Omarchy's preinstalled YouTube app.

`kanata/setup.sh` grants raw keyboard access through the `input` group, as required by Kanata's official Linux setup. Any process running as this user can then read keyboard events.

## Why sublayers use tap activation

Some laptop keyboards cannot report every three-key combination. For example, the keyboard may report Caps Lock and `S`, but suppress `K` or `L` while both remain held. This is a hardware or keyboard-firmware rollover limitation: Kanata enters the correct sublayer, but it cannot handle a final key event that the keyboard never sends. Which combinations fail depends on the keyboard matrix, so similar shortcuts may still work with other keys or an external keyboard.

Hyper sublayers therefore use a two-second one-shot layer. Both interaction styles are supported when the keyboard can report the held chord:

- Hold Caps Lock and the sublayer key, then press the action key.
- Hold Caps Lock, tap and release the sublayer key, then press the action key within two seconds.

For example, if holding `Caps Lock + S + K` does not change brightness, hold Caps Lock, tap and release `S`, then press `K`. Releasing the sublayer key reduces the physical combination to two simultaneous keys and avoids the rollover limitation.
