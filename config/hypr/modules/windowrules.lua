--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Float file pickers / dialogs
hl.window_rule({
	name = "float-file-dialogs",
	match = { title = "^(Open|Save|Save As|Open File|Open Folder).*$" },
	float = true,
	size = "900 600",
	center = true,
})

-- Float wiremix
hl.window_rule({
    name = "float-wiremix",
    match = { 
        class = "wiremix" -- Using class is much more reliable here
    },
    float = true,
    size = "800 500",
    center = true,
})

-- Picture-in-picture (Firefox, mpv)
hl.window_rule({
	name = "pip",
	match = { title = "^Picture-in-Picture$" },
	float = true,
	pin = true,
	size = "480 270",
	move = "85% 82%",
})

-- Thunar: float small utility windows (rename, progress)
hl.window_rule({
	name = "thunar-util",
	match = { class = "^thunar$", title = "^(Rename|Progress|Transferring).*$" },
	float = true,
	center = true,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- Native Lua API structure
hl.layer_rule({
	match = { namespace = "waybar" },
	blur = true,
	ignore_alpha = 0,
})

hl.layer_rule({
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 0,
})

