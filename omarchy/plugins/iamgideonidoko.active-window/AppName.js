function lookup(appId, title, entries) {
  if (!appId) return ""
  var id = String(appId).replace(/\.desktop$/i, "").toLowerCase()
  entries = entries || []

  for (var i = 0; i < entries.length; i++) {
    var entry = entries[i]
    if (String(entry.id).replace(/\.desktop$/i, "").toLowerCase() === id)
      return entry.name || appId
  }

  var webapp = id.match(/^[a-z0-9-]+-([a-z0-9.-]+\.[a-z]{2,})(?:_|-)/)
  if (webapp) {
    var host = webapp[1].replace(/^www\./, "")
    for (var j = 0; j < entries.length; j++) {
      var command = String(entries[j].execString || "")
      if (!/omarchy-launch-webapp|--app=/.test(command)) continue
      var url = command.match(/https?:\/\/([^/\s"']+)/i)
      if (url && url[1].toLowerCase().replace(/^www\./, "") === host)
        return entries[j].name || appId
    }
    for (var h = 0; h < entries.length; h++) {
      var handler = String(entries[h].execString || "").match(/omarchy-webapp-handler-([a-z0-9-]+)/i)
      if (handler && host.split(".").indexOf(handler[1].toLowerCase()) !== -1)
        return entries[h].name || appId
    }
  }

  if (/^tui\.(float|tile)$/.test(id)) {
    var windowTitle = String(title || "").trim()
    var firstWord = (windowTitle.toLowerCase().match(/^[a-z0-9._-]+/) || [""])[0]
    var matchingLaunchers = []
    for (var k = 0; k < entries.length; k++) {
      var launcher = entries[k]
      var exec = String(launcher.execString || "").toLowerCase()
      if (exec.indexOf("--app-id=" + id) === -1) continue
      matchingLaunchers.push(launcher)
      var name = String(launcher.name || "").toLowerCase()
      if (name.length > 3 && windowTitle.toLowerCase().indexOf(name) !== -1)
        return launcher.name
      var commandText = exec.split(/\s-e\s/)[1] || ""
      if (firstWord.length > 2 && !/^(bash|zsh|fish|sh)$/.test(firstWord) &&
          commandText.split(/[^a-z0-9._-]+/).indexOf(firstWord) !== -1)
        return launcher.name
    }
    // ponytail: generic TUI IDs identify one launcher only; use distinct app IDs when multiple share one style.
    if (matchingLaunchers.length === 1 && /^(|bash|zsh|fish|sh|ghostty)$/i.test(windowTitle))
      return matchingLaunchers[0].name || appId
    return windowTitle || appId
  }

  return appId
}
