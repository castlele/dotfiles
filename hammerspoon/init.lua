---@diagnostic disable: undefined-global

---@param path string
local function openApp(path)
   if not hs.application.launchOrFocus(path) then
      hs.alert.show("Application wasn't found: " .. app)
   end
end

-- TODO: Use PATH variables to get this apps
local apps = {
   ["Ghostty.app"] = "T", -- Terminal
   ["Arc.app"] = "B", -- Browser
   ["Godot.app"] = "G", -- Game engine
   ["Telegram.app"] = "M", -- Messanger
   ["Music.app"] = "P", -- Player
   ["Nirvana.app"] = "N", -- Nirvana
   ["Obsidian.app"] = "O", -- Obsidian
}

for appPath, key in pairs(apps) do
   hs.hotkey.bind({ "cmd", "alt", "ctrl" }, key, function()
      openApp(appPath)
   end)
end

hs.loadSpoon("Cherry")
