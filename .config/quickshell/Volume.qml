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

    property var mirror: null

    property string volumeFile:
        Quickshell.env("HOME") + "/.cache/quickshell/volume"

    readonly property real displayVolume:
        mirror ? mirror.volume : volume

    readonly property bool displayMuted:
        mirror ? mirror.muted : muted

    Process {
        id: getVolume

        command: [
            "wpctl",
            "get-volume",
            "@DEFAULT_AUDIO_SINK@"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                if (root.mirror)
                    return

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
        id: getSavedVolume

        command: [
            "sh",
            "-c",
            "if [ -f \"$1\" ]; then cat \"$1\"; fi",
            "sh",
            root.volumeFile
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                const value = parseInt(text.trim())

                if (!isNaN(value) && value >= 0 && value <= 100) {
                    root.volume = value
                    root.muted = false

                    setVolume.running = false
                    setVolume.running = true
                } else {
                    getVolume.running = true
                }
            }
        }
    }

    Process {
        id: saveVolume

        command: [
            "sh",
            "-c",
            "mkdir -p \"$(dirname \"$1\")\" && printf '%s\\n' \"$2\" > \"$1\"",
            "sh",
            root.volumeFile,
            root.volume.toString()
        ]
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
        if (!root.mirror)
            getSavedVolume.running = true
    }

    Text {
        anchors.fill: parent

        text: {
            if (root.displayMuted || root.displayVolume === 0)
                return "󰖁"

            if (root.displayVolume < 50)
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
            root.toggleMuted()
        }
    }

    function setVolumeValue(value) {
        if (root.mirror) {
            root.mirror.setVolumeValue(value)
            return
        }

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

        saveVolume.running = false
        saveVolume.running = true
    }

    function applyMute() {
        setMute.running = false
        setMute.running = true
    }

    function toggleMuted() {
        if (root.mirror) {
            root.mirror.muted = !root.mirror.muted
            root.mirror.applyMute()
            return
        }

        root.muted = !root.muted
        root.applyMute()
    }
}
