import QtQuick
import Quickshell
import Quickshell.Hyprland

Text {
    id: root

    width: 500

    text: Hyprland.activeToplevel
        ? Hyprland.activeToplevel.title
        : ""

    elide: Text.ElideRight

    horizontalAlignment: Text.AlignHCenter

    color: Colors.md3.on_surface

    font.family: "JetBrainsMonoNL Nerd Font Mono"
    font.bold: true
    font.pixelSize: 15

    // Waybar max-length: 50
    // QML doesn't have the exact same property,
    // so truncate manually.
    onTextChanged: {
        if (text.length > 50)
            text = text.substring(0, 50) + "…"
    }
}import QtQuick
import Quickshell
import Quickshell.Hyprland

Text {
    id: root

    width: 500

    text: Hyprland.activeToplevel
        ? Hyprland.activeToplevel.title
        : ""

    elide: Text.ElideRight

    horizontalAlignment: Text.AlignHCenter

    color: Colors.md3.on_surface

    font.family: "JetBrainsMonoNL Nerd Font Mono"
    font.bold: true
    font.pixelSize: 15

    // Waybar max-length: 50
    // QML doesn't have the exact same property,
    // so truncate manually.
    onTextChanged: {
        if (text.length > 50)
            text = text.substring(0, 50) + "…"
    }
}
