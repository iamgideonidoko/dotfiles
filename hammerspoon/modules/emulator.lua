function focusAndroidEmulator()
  local win = hs.window.filter.new("qemu-system-aarch64"):getWindows()
  if win and #win > 0 then
    win[1]:focus() -- Bring the first matching window to the front
  else
    hs.alert.show("Android Emulator is not running")
  end
end

-- Register the function to be called via URL
hs.urlevent.bind("focusAndroidEmulator", focusAndroidEmulator)
