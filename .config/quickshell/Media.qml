import QtQuick
import Quickshell.Services.Mpris

Item {
    id: root

    width: mediaRow.implicitWidth
    height: 30

    property var player: {
        const players = Mpris.players.values

        for (const p of players) {
            if (p.isPlaying)
                return p
        }

        return players.length > 0 ? players[0] : null
    }

    visible: player !== null

    Row {
        id: mediaRow

        anchors.verticalCenter: parent.verticalCenter

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

    running: mediaText.implicitWidth > mediaText.parent.width

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

        Text {
            width: 20
            height: 30

            text: "♪"

            color: Colors.md3.on_surface

            font.family: "JetBrainsMonoNL Nerd Font Mono"
            font.pixelSize: 18

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
