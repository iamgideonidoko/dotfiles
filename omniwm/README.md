# OmniWM desktop

OmniWM is the macOS desktop's window manager, with Dwindle and Niri layouts,
animations, and a native workspace bar. Linux/Omarchy configuration is unchanged.

```sh
make omniwm # Link configs, build Karabiner, activate OmniWM
```

`make macos-setup` selects OmniWM too. Activation backs up affected motion,
Spaces, and window-corner preferences and each display's wallpaper under
`~/.local/state/dotfiles/window-manager/preferences.json`. Repeated activation
keeps the original backup for manual recovery; setup failures retain it.
Changing Reduce Motion requires an administrator password when its current value
differs. An already-correct value is left alone.

Startup uses `~/Library/LaunchAgents/com.dotfiles.omniwm.plist`. Leave OmniWM's
own Start at Login switch off to avoid duplicate startup. Activation removes
OmniWM's native login entry before installing the managed LaunchAgent.
Karabiner's `dotfiles_omniwm` variable enables the OmniWM-only terminal and
screenshot shortcuts; the startup agent restores it at login.

SketchyVim remains enabled. Its mode/command-line hook is a no-op because the
upstream binary invokes that file unconditionally.

## First launch

- Grant OmniWM **Accessibility** and **Input Monitoring** in System Settings.
- Grant **Screen Recording** for Overview thumbnails and hover previews.
- Log out and back in after enabling **Displays have separate Spaces**. Setup
  enables this setting but never forces a logout. Prefer one native Space per
  display; navigate with OmniWM workspaces.
- Workspace, Overview, and column-scroll gestures are currently disabled. If
  enabling them, disable matching macOS gestures under Trackpad → More Gestures
  and give each enabled OmniWM gesture a non-conflicting finger count/axis.
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
| Option + − / = | Shrink/grow Dwindle window or Niri column (5% steps) |
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
window picker. Window navigation and emulator reuse require OmniWM IPC. An IPC
failure aborts rather than launching duplicate apps or emulators. App launchers
use native macOS activation when OmniWM is not running.

Workspaces 1–10 initially use the main display. Number shortcuts are global;
they focus the workspace on whichever display currently owns it. Workspace
transfers are temporary and reset to the configured home display on restart or
configuration reapply. No workspace numbers are reserved for external monitors.
Move a workspace to an external display with Control + Option + Shift + H/J/K/L
before using tiles there; a display with no assigned workspace has no tiled area.
Tile swaps use Move Container; tab joining/extraction remains accessible through
the command palette. Karabiner dispatches Option + − / = through `dotfiles-window`
to the active layout's resize command, so OmniWM's native resize chords remain
unassigned. Niri starts with 49% columns and two visible containers, no automatic
centering or looping, and no extra inner gaps at the viewport edges. Width presets
are one-third, 49%, two-thirds, and full width. The resize helper uses fixed 5%
steps to match `niri.resizeStepPercent`.

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
and login startup.

Initial verification passed IPC ping, config loading with ten Dwindle workspaces,
workspace 10 switching and restoration, and native bar queries. Automated tests
cover preference backups, per-display wallpaper restoration, missing preferences,
activation failures, window helpers, IPC failures, and native app launching. Live
window-focus verification and animation/display handoff remain pending completion
of the separate Spaces logout/login step.

Sources: [v0.7.6 source](https://github.com/OmniNull/OmniWM/tree/v0.7.6),
[configuration](https://omniwm.app/config/configuration/),
[compatibility](https://omniwm.app/help/known-limitations/).
