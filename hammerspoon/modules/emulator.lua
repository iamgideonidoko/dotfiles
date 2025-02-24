local spinUpFirstAndroidEmulator = function()
  local emulatorPath = "/Users/" .. os.getenv("USER") .. "/Library/Android/sdk/emulator/emulator"
  -- Get the first available AVD
  local handle = io.popen(emulatorPath .. " -list-avds", "r")
  if not handle then
    hs.alert.show("Failed to list emulators")
    return
  end
  local avdList = handle:read("*a")
  handle:close()
  -- Extract the first AVD name
  ---@type string|nil
  local firstAVD = avdList:match("([^\n]+)")
  if firstAVD then
    hs.task.new(emulatorPath, nil, { "-avd", firstAVD }):start()
  else
    hs.alert.show("No emulators found!")
  end
end

local openAndroidEmulator = function()
  local win = hs.window.filter.new("qemu-system-aarch64"):getWindows()
  if win and #win > 0 then
    win[1]:focus() -- Bring the first matching window to the front
  else
    spinUpFirstAndroidEmulator()
  end
end

-- Register the function to be called via URL
hs.urlevent.bind("openAndroidEmulator", openAndroidEmulator)
