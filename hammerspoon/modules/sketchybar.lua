local wf = hs.window.filter.new(nil)

-- Subscribe to window focus changes
wf:subscribe(hs.window.filter.windowFocused, function(win)
  if not win then
    return
  end
  hs.task.new("/bin/bash", nil, { "-c", "/opt/homebrew/bin/sketchybar --trigger hammerspoon_windows_change" }):start()
end)
