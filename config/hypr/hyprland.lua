-------------------------------
----Zafor's HYPERLAND config----
-------------------------------
---------------------
----Imported file----
---------------------

-- require("myColors")

------------------
---- MONITORS ----
------------------
---
hl.monitor({
	output = "HDMI-A-3",
	mode = "1920x1080@60",
	position = "0x0",
	scale = "1",
})

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "kitty"
local fileManager = "thunar"
local launcher = "pkill rofi || rofi -show drun"
local browser = "helium-browser"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	-- 1. Critical Environment Setup (Must run first)
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

	-- 2. Core Desktop Components & Background Daemons
	-- Authentication Agent
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	-- UI & Daemons
	hl.exec_cmd("waybar")
	hl.exec_cmd("swaync")
	-- Spin up the daemon, wait half a second, then restore your last wallpaper
	hl.exec_cmd("awww-daemon && sleep 0.5 && awww restore")
	-- Clipboard (Use a single line for both types to save space)
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	
  hl.exec_cmd("/usr/bin/ABDownloadManager --background")
end)

--------------------------------
---- ENVIRONMENT VARIABLES ----
--------------------------------

-- Cursor Styling (Keep these so your mouse look matches)
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("XCURSOR_THEME", "BreezeX-RosePine-Linux")

-- Intel VA-API (Keep these for hardware acceleration on UHD 630)
hl.env("LIBVA_DRIVER_NAME", "iHD")
hl.env("VDPAU_DRIVER", "va_gl")

-- Qt Customization (Keep this so your Qt apps use qt6ct for themes)
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

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

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 500, dampening = 41 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

--Layouts
hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

hl.config({
	master = {
		new_status = "master",
	},
})

hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

--terminal
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))

--window managements
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + G", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + T", hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }))

--Apps
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exec_cmd("poweroff"))

-- Clipboard history (requires cliphist + rofi)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("$HOME/.config/waybar/scripts/waybar-reload.sh"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("$HOME/.local/share/bin/wall-change.sh"))

-- Focus: vim-style
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move windows: mainMod + SHIFT + vim
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- Move windows with mainMod + SHIFT + arrow keys
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Resize: mainMod + ALT + vim
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.resize({ x = -30, y = 0, relative = true }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.resize({ x = 30, y = 0, relative = true }))
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.resize({ x = 0, y = -30, relative = true }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.resize({ x = 0, y = 30, relative = true }))

-- Resize: mainMod + ALT + vim
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }))
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.resize({ x = 0, y = -30, relative = true }))
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.resize({ x = 0, y = 30, relative = true }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

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
