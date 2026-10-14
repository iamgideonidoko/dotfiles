# Karabiner

macOS Hyper-key layers. Edit [rules.ts](./rules.ts) and [utils.ts](./utils.ts);
the build generates `karabiner.json`.

Run from the repo root:

```sh
yarn --cwd karabiner install
make karabiner                 # Build
yarn --cwd karabiner watch     # Rebuild on changes
```

`make macos-setup` installs and links the config. Restart Karabiner, grant its
permissions, and select your keyboard. App/window shortcuts use
[dotfiles-window](../macos/window); see [OmniWM](../omniwm/README.md) for bindings.
Hyper + O + A returns to the last focused window of a different app across
workspaces and displays. The focus-history login agent
records window IDs from OmniWM focus events.
