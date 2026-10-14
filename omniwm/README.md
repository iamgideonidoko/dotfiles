# OmniWM desktop

Stable OmniWM v0.7.6 replaces the active AeroSpace desktop, using Dwindle tiling,
animations, the native workspace bar, and native focus borders. AeroSpace,
SketchyBar, and JankyBorders remain installed and their original configs remain
in this repository. Linux/Omarchy configuration is unchanged.

```sh
make omniwm    # Link configs, build Karabiner, activate OmniWM
make aerospace # Restore preferences and the legacy desktop
```

`make macos-setup` now selects OmniWM too. Switch scripts back up affected motion,
Spaces, and window-corner preferences and each display's wallpaper under
`~/.local/state/dotfiles/window-manager/preferences.json`. Repeated activation
keeps the original backup; successful rollback removes it. Failures retain it.
Changing Reduce Motion requires an administrator password when its current value
differs. An already-correct value is left alone.

Startup uses `~/Library/LaunchAgents/com.dotfiles.omniwm.plist`. Leave OmniWM's
own Start at Login switch off to avoid duplicate startup. Activation removes
the AeroSpace login item after quitting it; rollback launches AeroSpace, whose
original `start-at-login = true` config restores its login registration.
Karabiner's `dotfiles_omniwm` variable enables the OmniWM-only terminal and
screenshot shortcuts; the startup agent restores it at login.

## First launch

- Grant OmniWM **Accessibility** and **Input Monitoring** in System Settings.
- Grant **Screen Recording** for Overview thumbnails and hover previews.
- Log out and back in after enabling **Displays have separate Spaces**. Setup
  enables this setting but never forces a logout. Prefer one native Space per
  display; navigate with OmniWM workspaces.
- Disable macOS three-finger desktop swipes and four-finger Mission Control
  gestures under Trackpad → More Gestures. OmniWM uses three-finger horizontal
  workspace swipes and four-finger vertical Overview swipes. Its trackpad
  column scrolling is disabled so gesture assignments cannot overlap.
- Fully quit and reopen affected apps for the 8-point system window corners.
  Apps drawing their own chrome may ignore this setting.

## Shortcuts

| Shortcut | Action |
| --- | --- |
| Option + H/J/K/L | Focus left/down/up/right |
| Option + Shift + H/J/K/L | Swap whole tiles/containers |
| Option + 1–9 / 0 | Workspace 1–9 / 10 |
| Option + Shift + 1–9 / 0 | Move window to workspace and follow |
| Option + A | Last active workspace |
| Option + Return | Toggle floating |
| Option + Tab | Switch floating/tiled focus |
| Option + F | OmniWM fullscreen within current workspace |
| Option + Shift + F | macOS native fullscreen Space |
| Option + / | Toggle Dwindle split |
| Option + . | Toggle Dwindle/Niri |
| Option + − / = | Shrink/grow focused Dwindle window |
| Option + Shift + B | Balance tile sizes |
| Control + Option + Shift + H/J/K/L | Move workspace to adjacent display |
| Option + Space | Palette: windows, menus, clipboard, commands, apps, files |
| Control + Option + M | App menus at cursor |
| Option + Shift + O | Overview |
| Option + grave accent | Quake terminal |
| Option + Shift + ; | Standalone Ghostty |
| Option + Shift + S | Screenshot selection to clipboard |
| Option + left/right mouse drag | Swap/resize windows |

Caps Lock Hyper layers remain in Karabiner. App launchers focus an existing
OmniWM window across workspaces before launching an app. `wps` remains an fzf
window picker. Both helpers retain AeroSpace support. An IPC failure aborts
navigation rather than launching duplicate apps or emulators.

Workspaces 1–10 initially use the main display. Number shortcuts are global;
they focus the workspace on whichever display currently owns it. Workspace
transfers are temporary and reset to the configured home display on restart or
configuration reapply. No workspace numbers are reserved for external monitors.
Move a workspace to an external display with Control + Option + Shift + H/J/K/L
before using tiles there; a display with no assigned workspace has no tiled area.
Tile swaps use Move Container; tab joining/extraction remains accessible through
the command palette. Dwindle resize shortcuts do not resize Niri columns; use
Option + right-drag there.

## Configuration and checks

`~/.config/omniwm` links to this directory. OmniWM atomically rewrites settings
from its UI, so linking the directory keeps those edits in Git. Review the diff
after UI edits or upgrades. Keep generated state and clipboard data outside Git.

The config uses the complete version 4 schema and retains the release's 13
minimum-size app rules. Unknown/duplicate action IDs or missing required fields
reject the whole file. Settings → Troubleshooting reports rejected config and
hotkey conflicts. Hidden Bar concealment remains disabled on macOS 26.

```sh
python3 macos/test-window-manager.py
bash macos/test-window.sh
python3 macos/window-manager.py --dry-run
bash macos-setup.sh --dry-run
omniwmctl ping
omniwmctl query workspaces --json
```

Manually check motion, three-window splits/swaps, fullscreen restoration,
workspace 10, move-and-follow, Hyper launchers, emulator reuse, and native bar
placement. On multiple displays check workspace transfers, disconnect/reconnect,
and login startup. Check rollback separately after saving your current layout.

Initial verification passed IPC ping, config loading with ten Dwindle workspaces,
workspace 10 switching and restoration, and native bar queries. Automated tests
cover preference backups, per-display wallpaper restoration, missing preferences,
rollback failures, window helpers, IPC failures, and AeroSpace fallback. Live
window-focus verification and animation/display handoff remain pending completion
of the separate Spaces logout/login step.

Sources: [v0.7.6 source](https://github.com/OmniNull/OmniWM/tree/v0.7.6),
[configuration](https://omniwm.app/config/configuration/),
[compatibility](https://omniwm.app/help/known-limitations/).
