-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- ====== Helper functions ======

--- Float all children, tile the main window
local function float_tile(class, main_title)
	hl.window_rule({ match = { class = class }, float = true })
	hl.window_rule({ match = { class = class, title = main_title }, tile = true })
end

--- Float and center a window, optionally with a specific size
local function float_center(class, title, width, height)
	local rule = { match = { class = class, title = title }, float = true, center = true }
	if width and height then
		rule.size = { width, height }
	end
	hl.window_rule(rule)
end

--- Send matching windows to the hidden garbage workspace and make them invisible
local function discard(match)
	hl.window_rule({
		match = match,
		workspace = "special:garbage silent",
		opacity = 0,
	})
end

-- ====== Float children + tile main window ======

-- Steam: float children, tile the main Steam window
float_tile("^(steam)$", "^(Steam)$")
-- QQ: float children, tile the main QQ window
float_tile("^(QQ)$", "^(QQ)$")
-- WeChat: float children, tile the main WeChat window
float_tile("^(wechat)$", "^(微信)$")

-- ====== Float and center ======

-- Firefox: float and center the subwindows
float_center("^(firefox)$", "^(我的足迹)$", 800, 600)
float_center("^(firefox)$", "^正在打开.*$")

-- Zed: float and center the settings window
float_center("^(dev.zed.Zed)$", "^(Zed — Settings)$", 1000, 800)

-- An anime game launcher
float_center("^(moe.launcher.an-anime-game-launcher)$", "^(An Anime Game Launcher)$")

-- Btrfs Assistant
float_center("^(btrfs-assistant)$")

-- Blank Wine windows (class + title both empty, xwayland)
discard({ class = "^$", title = "^$", xwayland = 1 })

-- Blank Qt SNI proxy windows (xembedsniproxy, e.g. leftover tray icons)
discard({ class = "^(xembedsniproxy)$", title = "^$", xwayland = 1 })

-- ====== One-off rules ======

-- Prevent virt-manager/QEMU from inhibiting Hyprland keyboard shortcuts
-- (no_shortcuts_inhibit disallows the app from inhibiting your shortcuts)
-- This lets SUPER+F, SUPER+1/2/3, etc. work even when VM is fullscreen
hl.window_rule({ match = { class = "^(virt-manager)$" }, no_shortcuts_inhibit = true })
