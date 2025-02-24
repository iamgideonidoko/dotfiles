local toggleCapsLock = function()
  local capsState = hs.hid.capslock.get()
  hs.hid.capslock.set(not capsState)
end

-- Register the function to be called via URL
hs.urlevent.bind("toggleCapsLock", toggleCapsLock)
