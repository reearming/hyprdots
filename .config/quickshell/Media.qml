import QtQuick
import Quickshell.Services.Mpris

Item {
    id: root

    property var player: {
        const players = Mpris.players.values

        for (const p of players) {
            if (p.isPlaying)
                return p
        }

        return players.length > 0 ? players[0] : null
    }

    property var volumeMirror: null

    visible: player !== null

    implicitWidth: mediaColumn.implicitWidth
    implicitHeight: mediaColumn.implicitHeight

    Column {
        id: mediaColumn

        spacing: 5

        Row {
            id: titleRow

            spacing: 5

            Text {
                width: 20
                height: 30

                text: "♫"

                color: Colors.md3.on_surface

                font.family: "JetBrainsMonoNL Nerd Font Mono"
                font.pixelSize: 18

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Item {
                width: Math.min(mediaText.implicitWidth, 250)
                height: 30

                clip: true

                Text {
                    id: mediaText

                    height: parent.height

                    text: {
                        if (!root.player)
                            return ""

                        const title = root.player.trackTitle
                        const artist = root.player.trackArtist

                        if (artist !== "")
                            return title + " — " + artist

                        return title
                    }

                    color: Colors.md3.on_surface

                    font.family: "JetBrainsMonoNL Nerd Font Mono"
                    font.bold: true
                    font.pixelSize: 14

                    verticalAlignment: Text.AlignVCenter

                    x: {
                        if (implicitWidth <= parent.width)
                            return 0

                        const range = implicitWidth - parent.width

                        return -range * (marqueeProgress / 100)
                    }

                    property real marqueeProgress: 0

                    SequentialAnimation on marqueeProgress {
                        id: marqueeAnimation

                        running:
                            mediaText.implicitWidth
                            > mediaText.parent.width

                        loops: Animation.Infinite

                        PauseAnimation {
                            duration: 1200
                        }

                        NumberAnimation {
                            from: 0
                            to: 100

                            duration: Math.max(
                                3000,
                                mediaText.implicitWidth * 35
                            )

                            easing.type: Easing.InOutSine
                        }

                        PauseAnimation {
                            duration: 1200
                        }

                        NumberAnimation {
                            from: 100
                            to: 0

                            duration: Math.max(
                                1200,
                                mediaText.implicitWidth * 15
                            )

                            easing.type: Easing.InOutCubic
                        }

                        PauseAnimation {
                            duration: 800
                        }

                        onRunningChanged: {
                            if (!running)
                                mediaText.marqueeProgress = 0
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    hoverEnabled: true

                    onEntered: {
                        marqueeAnimation.pause()
                    }

                    onExited: {
                        marqueeAnimation.resume()
                    }
                }
            }
        }

        Row {
            id: controlsRow

            spacing: 5

            Text {
                width: 20
                height: 30

                text: "󰒮"

                color: Colors.md3.on_surface

                font.family: "JetBrainsMonoNL Nerd Font Mono"
                font.pixelSize: 18

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        if (root.player)
                            root.player.previous()
                    }
                }
            }

            Text {
                width: 20
                height: 30

                text: root.player && root.player.isPlaying
                    ? "󰏤"
                    : "󰐊"

                color: Colors.md3.on_surface

                font.family: "JetBrainsMonoNL Nerd Font Mono"
                font.pixelSize: 18

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        if (root.player)
                            root.player.togglePlaying()
                    }
                }
            }

            Text {
                width: 20
                height: 30

                text: "󰒭"

                color: Colors.md3.on_surface

                font.family: "JetBrainsMonoNL Nerd Font Mono"
                font.pixelSize: 18

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        if (root.player)
                            root.player.next()
                    }
                }
            }

            Item {
                width: 5
                height: 30
            }

            Volume {
                id: mediaVolume

                mirror: root.volumeMirror
            }

            Rectangle {
                id: mediaVolumeSlider

                width: 120
                height: 8

                anchors.verticalCenter: parent.verticalCenter

                radius: 4

                color: Colors.md3.surface_variant

                Rectangle {
                    width:
                        parent.width
                        * mediaVolume.displayVolume
                        / 100

                    height: parent.height

                    radius: 4

                    color: Colors.md3.primary
                }

                MouseArea {
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        bottom: parent.bottom

                        topMargin: -12
                        bottomMargin: -12
                    }

                    onClicked: {
                        mediaVolume.setVolumeValue(
                            Math.max(
                                0,
                                Math.min(
                                    100,
                                    mouseX
                                        / mediaVolumeSlider.width
                                        * 100
                                )
                            )
                        )
                    }

                    onPositionChanged: {
                        if (pressed) {
                            mediaVolume.setVolumeValue(
                                Math.max(
                                    0,
                                    Math.min(
                                        100,
                                        mouseX
                                            / mediaVolumeSlider.width
                                            * 100
                                    )
                                )
                            )
                        }
                    }
                }

                Rectangle {
                    width: 16
                    height: 16

                    radius: 8

                    x:
                        mediaVolumeSlider.width
                        * mediaVolume.displayVolume
                        / 100
                        - width / 2

                    anchors.verticalCenter: parent.verticalCenter

                    color: Colors.md3.primary
                }
            }
        }
    }
}
