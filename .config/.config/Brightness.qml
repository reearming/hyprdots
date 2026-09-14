import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    width: 30
    height: 30

    property int brightness: 50
    property bool hovered: mouseArea.containsMouse

    property string brightnessFile:
        Quickshell.env("HOME") + "/.cache/quickshell/brightness"

    Process {
        id: getBrightness

        command: [
            "ddcutil",
            "--display", "1",
            "getvcp", "10"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/current value = (\d+)/)

                if (match)
                    root.brightness = parseInt(match[1])

                saveBrightness.running = false
                saveBrightness.running = true
            }
        }
    }

    Process {
        id: getSavedBrightness

        command: [
            "sh",
            "-c",
            "if [ -f \"$1\" ]; then cat \"$1\"; fi",
            "sh",
            root.brightnessFile
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const value = parseInt(text.trim())

                if (!isNaN(value) && value >= 0 && value <= 100) {
                    root.brightness = value

                    setBrightness.running = false
                    setBrightness.running = true
                } else {
                    getBrightness.running = true
                }
            }
        }
    }

    Process {
        id: setBrightness

        command: [
            "ddcutil",
            "--display", "1",
            "setvcp", "10",
            root.brightness.toString()
        ]
    }

    Process {
        id: saveBrightness

        command: [
            "sh",
            "-c",
            "mkdir -p \"$(dirname \"$1\")\" && printf '%s\\n' \"$2\" > \"$1\"",
            "sh",
            root.brightnessFile,
            root.brightness.toString()
        ]
    }

    Component.onCompleted: {
        getSavedBrightness.running = true
    }

    Text {
        anchors.fill: parent

        text: {
            if (root.brightness <= 20)
                return "󰃞"

            if (root.brightness <= 60)
                return "󰃟"

            return "󰃠"
        }

        color: Colors.md3.on_surface

        font.family: "JetBrainsMonoNL Nerd Font Mono"
        font.pixelSize: 18

        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }

    function setBrightnessValue(value) {
        root.brightness = Math.round(
            Math.max(
                0,
                Math.min(100, value)
            )
        )

        setBrightness.running = false
        setBrightness.running = true

        saveBrightness.running = false
        saveBrightness.running = true
    }
}
