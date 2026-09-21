const assert = require("node:assert/strict")
const fs = require("node:fs")
const path = require("node:path")
const vm = require("node:vm")

const source = fs.readFileSync(path.join(__dirname, "../omarchy/plugins/iamgideonidoko.active-window/AppName.js"), "utf8")
const lookup = vm.runInNewContext(source + "\nlookup", {})
const entries = [
  { id: "YouTube", name: "YouTube", execString: "omarchy-launch-webapp https://youtube.com/" },
  { id: "Google Photos", name: "Google Photos", execString: "omarchy-launch-webapp https://photos.google.com/" },
  { id: "Google Messages", name: "Google Messages", execString: "omarchy-launch-webapp https://messages.google.com/web/conversations" },
  { id: "Zoom", name: "Zoom", execString: "omarchy-webapp-handler-zoom %u" },
  { id: "Custom", name: "Custom", execString: "google-chrome --app=https://custom.example.org/" },
  { id: "Disk Usage", name: "Disk Usage", execString: 'xdg-terminal-exec --app-id=TUI.float -e bash -c "dua i /"' },
  { id: "Docker", name: "Docker", execString: "xdg-terminal-exec --app-id=TUI.tile -e omarchy-launch-docker-tui" },
  { id: "org.example.Editor", name: "Editor", execString: "editor" }
]

assert.equal(lookup("chrome-youtube.com__-Default", "YouTube", entries), "YouTube")
assert.equal(lookup("chrome-photos.google.com__-Default", "Photos", entries), "Google Photos")
assert.equal(lookup("chrome-messages.google.com_web_conversations-Default", "Messages", entries), "Google Messages")
assert.equal(lookup("chrome-app.zoom.us__-Default", "Zoom", entries), "Zoom")
assert.equal(lookup("brave-custom.example.org__-Default", "Custom", entries), "Custom")
assert.equal(lookup("TUI.float", "dua", entries), "Disk Usage")
assert.equal(lookup("TUI.float", "bash", entries), "Disk Usage")
assert.equal(lookup("TUI.tile", "lazydocker", entries), "Docker")
assert.equal(lookup("org.example.Editor", "file.txt", entries), "Editor")
assert.equal(lookup("TUI.float", "unknown", entries), "unknown")
assert.equal(lookup("", "", entries), "")
