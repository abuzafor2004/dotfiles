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
