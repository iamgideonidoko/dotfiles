require("modules.capslock")

-- Smartly reoload configuration
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
hs.alert.show("Hammersoon Config loaded")
