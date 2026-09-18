local directions = { H = "l", J = "d", K = "u", L = "r" }

-- Omarchy's old web-app shortcut collides with Alt+Shift+L window movement.
hl.unbind("ALT + SHIFT + L")

for key, direction in pairs(directions) do
  o.bind("ALT + " .. key, "Focus " .. direction, hl.dsp.focus({ direction = direction }))
  o.bind("ALT + SHIFT + " .. key, "Move window " .. direction, hl.dsp.window.swap({ direction = direction }))
end

for workspace = 1, 10 do
  local key = "code:" .. tostring(workspace + 9)
  o.bind("ALT + " .. key, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = tostring(workspace) }))
  o.bind("ALT + SHIFT + " .. key, "Move window to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace) }))
end

o.bind("ALT + RETURN", "Toggle floating", hl.dsp.window.float({ action = "toggle" }))
o.bind("ALT + F", "Fullscreen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("ALT + A", "Previous workspace", hl.dsp.focus({ workspace = "previous" }))
o.bind("ALT + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")

o.bind("SUPER + SHIFT + RETURN", "Browser", { omarchy = "browser" })
o.bind("SUPER + SHIFT + F", "File manager", { omarchy = "nautilus" })
o.bind("SUPER + CTRL + L", "Lock system", "omarchy-system-lock")
o.bind("PRINT", "Screenshot", "omarchy-capture-screenshot")
