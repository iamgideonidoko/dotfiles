local directions = { H = "l", J = "d", K = "u", L = "r" }

for _, key in ipairs({ "J", "K", "L" }) do
  hl.unbind("SUPER + " .. key)
end

for key, direction in pairs(directions) do
  o.bind("SUPER + " .. key, "Focus " .. direction, hl.dsp.focus({ direction = direction }))
  o.bind("SUPER + SHIFT + " .. key, "Move window " .. direction, hl.dsp.window.swap({ direction = direction }))
end

hl.unbind("SUPER + RETURN")
o.bind("SUPER + RETURN", "Toggle floating", hl.dsp.window.float({ action = "toggle" }))
o.bind("SUPER + A", "Previous workspace", hl.dsp.focus({ workspace = "previous" }))

hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")
