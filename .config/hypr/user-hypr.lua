mainmod = "SUPER"

hl.bind(mainmod .. " + SUPER_L", hl.dsp.exec_cmd("rofi -show drun"), {
  release = true
})

hl.bind("F13", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))
hl.bind(mainmod .. " + W", hl.dsp.exec_cmd("~/.local/bin/wallpaper-picker"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainmod .. " + V", hl.dsp.exec_cmd("~/.local/bin/clipboard-picker"))
hl.bind("Shift_L + Print", hl.dsp.exec_cmd("hyprshot -m output"))
hl.env("HYPRSHOT_DIR", "/home/reearming/Pictures/Screenshots")

hl.env("GTK_THEME", "adw-gtk-theme")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

hl.bind(mainmod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainmod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainmod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainmod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))

