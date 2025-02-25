local lastToggleTime = 0
local debounceDelay = 2.5

local toggleCapsLock = function()
  local now = hs.timer.secondsSinceEpoch()
  if now - lastToggleTime > debounceDelay then
    hs.hid.capslock.toggle()
    lastToggleTime = now
  end
end

-- Register the function to be called via URL
hs.urlevent.bind("toggleCapsLock", toggleCapsLock)
