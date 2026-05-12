-- Relevant Hyprland wiki section: https://wiki.hyprland.org/Configuring/Keywords/#executing

hl.on("hyprland.start", function()
	-- Clash Verge
	hl.exec_cmd("clash-verge")

	-- Wallpaper engine (disabled)
	-- hl.exec_cmd("linux-wallpaperengine --screen-root eDP-2 --silent 3596162860")

	-- Xresources (Xft.dpi: 153.6)
	hl.exec_cmd("xrdb -merge ~/.Xresources")

	-- Input Method
	hl.exec_cmd("fcitx5")

	-- Cursor
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")

	-- Wine games tray
	hl.exec_cmd("xembedsniproxy")
end)
