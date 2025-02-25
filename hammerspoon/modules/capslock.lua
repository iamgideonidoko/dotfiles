local toggleCapsLock = function()
  hs.hid.capslock.toggle()
end

-- Register the function to be called via URL
hs.urlevent.bind("toggleCapsLock", toggleCapsLock)
