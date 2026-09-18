-- Omarchy bootstrap and user-owned Hyprland configuration.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Keep core Omarchy window-manager bindings. Exclude preinstalled app and web-app shortcuts.
omarchy_preinstalled_bindings = false

require("default.hypr.omarchy")
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")
require("default.hypr.toggles")
