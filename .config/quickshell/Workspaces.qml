import QtQuick
import Quickshell
import Quickshell.Hyprland

Row {
    id: root

    anchors.leftMargin: 5
    spacing: 2

    Repeater {
        model: Hyprland.workspaces

        delegate: Rectangle {
            required property var modelData

            width: workspaceText.implicitWidth + 10
	    height: 28

            radius: 5

            color: modelData.active
                ? Colors.md3.primary
                : "transparent"

	    Text {
	        id: workspaceText
                anchors.centerIn: parent

                text: modelData.name

                color: modelData.active
                    ? Colors.md3.on_primary
                    : Colors.md3.on_surface

                font.family: "JetBrainsMonoNL Nerd Font Mono"
                font.bold: true
                font.pixelSize: 15
            }

            MouseArea {
                anchors.fill: parent

                onClicked: modelData.activate()
            }
        }
    }
}
