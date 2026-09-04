------------------------
---- LOOK AND FEEL ----
------------------------

hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 6,
		border_size = 0,
		col = {
			-- Gradient border on active window (catppuccin mocha palette)
			active_border = {
				colors = { "#403d52", "#524f67" },
				angle = 45,
			},
			inactive_border = "#21202e",
		},
		resize_on_border = true,
		allow_tearing = false, -- i5-10400 iGPU: keep false
		layout = "dwindle",
	},

	decoration = {
		rounding = 2,
		rounding_power = 3,

		active_opacity = 0.9,
		inactive_opacity = 0.85,

		shadow = {
			enabled = false,
			range = 8,
			render_power = 2,
			color = "rgba(1e1e2edd)",
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 2,
			vibrancy = 0.28, -- Slight performance tip for iGPU: lower passes if laggy

			new_optimizations = true,
			popups = true,
		},
	},
})

