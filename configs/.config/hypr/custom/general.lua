-- https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1.6", -- 2560x1440
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/
-- https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
	input = {
		kb_options = "caps:escape",
	},
	cursor = {
		hide_on_key_press = true,
		inactive_timeout = 1,
	},
})
