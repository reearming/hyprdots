import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    width: layoutText.implicitWidth
    height: 30

    property string layout: "--"

    Process {
        id: getLayout

        command: [
            "hyprctl",
            "devices",
            "-j"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text)

                    for (const keyboard of data.keyboards) {
                        if (keyboard.name === "keyd-virtual-keyboard") {
                            const keymap = keyboard.active_keymap.toLowerCase()

                            if (keymap.includes("russian")) {
                                root.layout = "RU"
                            } else if (keymap.includes("english")) {
                                root.layout = "EN"
                            } else {
                                root.layout = keyboard.active_keymap
                            }

                            break
                        }
                    }
                } catch (e) {
                    console.log(
                        "Failed to parse keyboard layout:",
                        e
                    )
                }
            }
        }
    }

    function updateLayout() {
        getLayout.running = false
        getLayout.running = true
    }

    Component.onCompleted: {
        updateLayout()
    }

    Timer {
        interval: 500
        running: true
        repeat: true

        onTriggered: {
            root.updateLayout()
        }
    }

    Text {
        id: layoutText

        anchors.fill: parent

        text: root.layout

        color: Colors.md3.on_surface

        font.family: "JetBrainsMonoNL Nerd Font Mono"
        font.bold: true
        font.pixelSize: 15

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
