-- Here's a list of every variable: https://wiki.hyprland.org/Configuring/Variables/

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1.6", -- 2560x1440
})

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
	input = {
		kb_options = "caps:escape",
	},
})
