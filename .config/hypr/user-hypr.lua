hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("rofi -show drun"), {
  release = true
})

hl.bind("F13", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("~/.local/bin/wallpaper-picker"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("~/.local/bin/clipboard-picker"))
hl.bind("Shift_L + Print", hl.dsp.exec_cmd("hyprshot -m output"))

