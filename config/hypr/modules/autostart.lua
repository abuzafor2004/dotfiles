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

