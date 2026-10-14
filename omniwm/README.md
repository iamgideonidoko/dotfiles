# OmniWM

macOS tiling with Dwindle, Niri, and the native workspace bar. Run from the repo root:

```sh
make omniwm # Link configs, build Karabiner, activate; also included in make macos-setup
```

## Setup

- Grant Accessibility and Input Monitoring; Screen Recording enables previews.
- Setup enables **Displays have separate Spaces**. Log out/in after changing it;
  prefer one native macOS Space per display.
- Leave OmniWM's **Start at Login** off: `~/Library/LaunchAgents/com.dotfiles.omniwm.plist`
  handles startup and enables Karabiner's OmniWM shortcuts.
- `com.dotfiles.window-focus.plist` records focus events for Hyper + O + A, bypassing
  OmniWM's previous-window history. It includes floating windows.
- Changing Reduce Motion may require an admin password. Reopen apps to apply the
  8-point system window corners; custom app chrome may ignore them.
- Gestures are disabled. If enabled, avoid conflicting finger counts/axes and
  disable matching macOS gestures.

Setup applies `wallpapers/min-apple.jpg` to all displays. Original preferences and
wallpapers remain backed up at `~/.local/state/dotfiles/window-manager/preferences.json`
for manual recovery; repeat runs and failures preserve that backup. SketchyVim's
mode hook is a no-op.

## Shortcuts

| Shortcut                            | Action                                                      |
| ----------------------------------- | ----------------------------------------------------------- |
| Alt + H/J/K/L                       | Focus left/down/up/right                                    |
| Alt + Shift + H/J/K/L               | Swap whole tiles/containers                                 |
| Alt + 1–9 / 0                       | Workspace 1–9 / 10; add Shift to move window and follow     |
| Alt + A                             | Previous active workspace                                   |
| Alt + Enter / Tab                   | Toggle floating / switch floating–tiled focus               |
| Alt + F                             | Workspace fullscreen; add Shift for native macOS fullscreen |
| Alt + /; Alt + .                    | Toggle Dwindle split / toggle Dwindle–Niri                  |
| Alt + − / =                         | Shrink/grow Dwindle window or Niri column (Niri: 5% steps)  |
| Alt + Shift + B                     | Balance sizes                                               |
| Ctrl + Alt + Shift + H/J/K/L        | Move workspace to adjacent display                          |
| Alt + Space                         | Window/app/file/command palette                             |
| Ctrl + Alt + M                      | App menus at cursor                                         |
| Alt + Shift + ; / S                 | Ghostty / screenshot selection to clipboard                 |
| Alt + left/right drag               | Swap/resize windows                                         |
| Alt + Shift + O; Alt + grave accent | Overview / Quake terminal (currently disabled)              |

Caps Lock Hyper layers stay in [Karabiner](../karabiner/README.md). `wps` picks windows
with fzf. [dotfiles-window](../macos/window) handles app/emulator reuse and layout-aware
resizing; IPC failures abort those actions. App launchers use native activation when
OmniWM isn't running; native resize bindings stay unassigned.

## Behavior overrides

| Action | Native behavior replaced | Dotfiles behavior |
| --- | --- | --- |
| Hyper + O + A | The old binding sent macOS Command+Tab, which switches apps and lets macOS choose the window. OmniWM's `focus previous` instead selects the previous tiled window, including windows of the same app. | Selects the last observed window of a different app across workspaces and displays; includes floating windows and skips closed windows. |
| Hyper app launchers | `open -a` activates an app; macOS chooses its window. | Reuses the app's focused window, reading its remembered macOS focus when several windows exist, then navigates to its workspace/display. Launches the app if no managed window exists. |
| Android emulator launcher | Starting the emulator directly can create another instance. | Navigates to an existing managed emulator window; otherwise starts the first configured AVD. |
| Alt + − / = | OmniWM exposes separate Dwindle and Niri resize commands. | Chooses the command for the current layout: Dwindle grow/shrink or a five-percent Niri column-width change. |
| Desktop setup/login | Preferences, wallpaper, and login startup are configured manually. | Backs up preferences/wallpaper, applies this setup, and installs the OmniWM and focus-history login agents. |

For example, after focusing Ghostty on 3, Chrome on 9, then Chrome on 10,
Hyper + O + A skips Chrome on 9 and returns to Ghostty. Pressing it again returns
to Chrome on 10.

[window](../macos/window) dispatches shortcuts;
[window-history.py](../macos/window-history.py) records focus events and selects the
previous app; [window-manager.py](../macos/window-manager.py) handles setup.
The history tracker bypasses OmniWM's built-in history, but still depends on its
focus events and navigation. It cannot recover focus changes OmniWM never reports.
The earlier 3↔9 failure was not conclusively isolated from stale Karabiner bindings.
App focus lookup requires Accessibility access from Karabiner's execution context;
lookup/IPC failures abort rather than select an arbitrary window.
The `test-window*` scripts only validate these helpers and do not run at login.
Tiling, workspace navigation, floating, and fullscreen remain handled by OmniWM.

## Layout and displays

Workspaces 1–10 start on Main. Move one to an external display before tiling there.
Number shortcuts are global; transfers reset to Home Monitor on restart/config reapply.
Tab joining/extraction is available through the palette.

Niri uses two visible containers, 49% default width, no automatic centering/looping,
and no extra edge gaps. Width presets: ⅓, 49%, ⅔, full. The resize helper uses fixed
5% steps, matching `niri.resizeStepPercent`.

## Config and checks

`~/.config/omniwm` links here: UI edits and upgrades change tracked settings, so review
Git diffs. Keep runtime/clipboard state outside Git. The strict schema rejects missing
required fields and unknown/duplicate actions; check Settings → Troubleshooting.
Hidden Bar needs macOS 27+. Native borders, Overview, and Quake are currently disabled.

```sh
python3 macos/test-window-manager.py
python3 macos/test-window-history.py
bash macos/test-window.sh
python3 macos/window-manager.py --dry-run
bash macos-setup.sh --dry-run
omniwmctl ping
omniwmctl query workspaces --json
```

Manually check focus, motion, splits/swaps, fullscreen restore, workspace transfers,
emulator reuse, bar placement, display reconnects, and login startup.

[Configuration](https://omniwm.app/config/configuration/) ·
[Compatibility](https://omniwm.app/help/known-limitations/) ·
[v0.7.6 source](https://github.com/OmniNull/OmniWM/tree/v0.7.6)
