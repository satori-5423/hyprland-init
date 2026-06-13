-- https://wiki.hypr.land/Configuring/Basics/Binds/

-- Window
hl.unbind("CTRL + SUPER + SHIFT + Up")
hl.unbind("CTRL + SUPER + SHIFT + Down")
hl.unbind("CTRL + SUPER + SHIFT + Left")
hl.unbind("CTRL + SUPER + SHIFT + Right")

hl.bind("CTRL + SUPER + SHIFT + Up", hl.dsp.window.move({ workspace = "r-5" }))
hl.bind("CTRL + SUPER + SHIFT + Down", hl.dsp.window.move({ workspace = "r+5" }))
hl.bind("CTRL + SUPER + SHIFT + Left", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind("CTRL + SUPER + SHIFT + Right", hl.dsp.window.move({ workspace = "r+1" }))

-- Lock screen (dispatch to Quickshell's lock handler)
hl.unbind("SUPER + L")
hl.bind("SUPER + L", hl.dsp.global("quickshell:lock"), { description = "Misc: Lock" })

-- Edit configs
hl.bind(
	"CTRL + SUPER + Slash",
	hl.dsp.exec_cmd("xdg-open ~/.config/illogical-impulse/config.json")
	-- { description = "Edit shell config" }
)

hl.bind(
	"CTRL + SUPER + ALT + Slash",
	hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua")
	-- { description = "Edit extra keybinds" }
)
