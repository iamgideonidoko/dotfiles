hl.config({
  input = {
    accel_profile = "flat",
    -- Kanata owns Caps Lock: tap toggles Caps Lock, hold activates Hyper.
    kb_options = "",
    touchpad = {
      natural_scroll = true,
      scroll_factor = 0.4,
      drag_3fg = 1,
    },
  },
})

-- Kanata owns this keyboard. Keep Hyprland from retaining a second, stale
-- Caps Lock state for the grabbed physical device.
hl.device({
  name = "at-translated-set-2-keyboard",
  enabled = false,
})
