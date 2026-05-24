-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Steam: float children, tile the main Steam window
hl.window_rule({match = {class = "^(steam)$"}, float = true})
hl.window_rule({match = {class = "^(steam)$", title = "^(Steam)$"}, tile = true})

-- QQ: float children, tile the main QQ window
hl.window_rule({match = {class = "^(QQ)$"}, float = true})
hl.window_rule({match = {class = "^(QQ)$", title = "^(QQ)$"}, tile = true})

-- WeChat: float children, tile the main WeChat window
hl.window_rule({match = {class = "^(wechat)$"}, float = true})
hl.window_rule({match = {class = "^(wechat)$", title = "^(微信)$"}, tile = true})

-- Discard blank Wine windows (class + title both empty, xwayland)
hl.window_rule({match = {class = "^$", title = "^$", xwayland = 1}, workspace = "special:garbage silent", opacity = 0})

-- Firefox: float and center the bookmarks window
hl.window_rule({match = {class = "^(firefox)$", title = "^(我的足迹)$"}, float = true, center = true, size = {800, 600}})

-- Prevent virt-manager/QEMU from inhibiting Hyprland keyboard shortcuts
-- (no_shortcuts_inhibit disallows the app from inhibiting your shortcuts)
-- This lets SUPER+F, SUPER+1/2/3, etc. work even when VM is fullscreen
hl.window_rule({match = {class = "^(virt-manager)$"}, no_shortcuts_inhibit = true})
