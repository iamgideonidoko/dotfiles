require("modules.capslock")
require("modules.emulator")

-- Smartly reload configuration
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
hs.alert.show("Hammersoon Config loaded")
