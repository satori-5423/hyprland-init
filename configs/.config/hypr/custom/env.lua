-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- Discrete GPU Card

-- Wayland
hl.env("AQ_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card2")

-- Xwayland
hl.env("DRI_PRIME", "pci-0000:03:00.0")

-- Locale
hl.env("LANG", "zh_CN.UTF-8")

-- Input Method
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "ibus")
hl.env("INPUT_METHOD", "fcitx")

-- Enable org.freedesktop.impl.portal.FileChooser = kde
hl.env("GTK_USE_PORTAL", "1")

-- EDITOR
hl.env("EDITOR", "nvim")

-- CMAKE_GENERATOR
hl.env("CMAKE_GENERATOR", "Ninja")

-- Cursor
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
