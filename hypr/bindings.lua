local directions = { H = "l", J = "d", K = "u", L = "r" }

for _, key in ipairs({ "J", "K", "L" }) do
  hl.unbind("SUPER + " .. key)
end

for key, direction in pairs(directions) do
  o.bind("SUPER + " .. key, "Focus " .. direction, hl.dsp.focus({ direction = direction }))
  o.bind("SUPER + SHIFT + " .. key, "Move window " .. direction, hl.dsp.window.swap({ direction = direction }))
end

hl.unbind("SUPER + SLASH")
o.bind("SUPER + SLASH", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + PERIOD", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
hl.unbind("SUPER + ALT + SLASH")
o.bind("SUPER + BRACKETLEFT", "Monitor scaling down", "omarchy-hyprland-monitor-scaling down")
o.bind("SUPER + BRACKETRIGHT", "Monitor scaling up", "omarchy-hyprland-monitor-scaling up")

hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Toggle floating", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + A", "Previous workspace", hl.dsp.focus({ workspace = "previous" }))

-- SUPER + SHIFT + SLASH was Passwords.
hl.unbind("SUPER + SHIFT + SLASH")
o.bind("SUPER + SHIFT + SLASH", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + SHIFT + SEMICOLON", "Terminal", { omarchy = "terminal" })
