import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    width: 30
    height: 30

    property real volume: 50
    property bool muted: false
    property bool hovered: mouseArea.containsMouse

    Process {
        id: getVolume

        command: [
            "wpctl",
            "get-volume",
            "@DEFAULT_AUDIO_SINK@"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/Volume:\s+([0-9.]+)/)

                if (match) {
                    root.volume =
                        Math.round(parseFloat(match[1]) * 100)
                }

                root.muted = text.includes("[MUTED]")
            }
        }
    }

    Process {
        id: setVolume

        command: [
            "wpctl",
            "set-volume",
            "@DEFAULT_AUDIO_SINK@",
            root.volume.toFixed(0) + "%"
        ]
    }

    Process {
        id: setMute

        command: [
            "wpctl",
            "set-mute",
            "@DEFAULT_AUDIO_SINK@",
            root.muted ? "1" : "0"
        ]
    }

    Component.onCompleted: {
        getVolume.running = true
    }

    Text {
        anchors.fill: parent

        text: {
            if (root.muted || root.volume === 0)
                return "󰖁"

            if (root.volume < 50)
                return "󰖀"

            return "󰕾"
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

        acceptedButtons: Qt.LeftButton

        onClicked: {
            root.muted = !root.muted

            setMute.running = false
            setMute.running = true
        }
    }

    function setVolumeValue(value) {
        root.volume = Math.round(
            Math.max(
                0,
                Math.min(100, value)
            )
        )

        if (root.muted) {
            root.muted = false

            setMute.running = false
            setMute.running = true
        }

        setVolume.running = false
        setVolume.running = true
    }
}
