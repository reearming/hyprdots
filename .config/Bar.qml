//@ pragma UseQApplication

import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    implicitHeight: screen.height
    exclusiveZone: 40
    color: "transparent"

    property bool mediaPopupOpen: false
    property bool brightnessPopupOpen: false
    property bool volumePopupOpen: false

    Timer {
        id: mediaCloseTimer

        interval: 250

        onTriggered: {
            bar.mediaPopupOpen = false
        }
    }

    Timer {
        id: brightnessCloseTimer

        interval: 250

        onTriggered: {
            bar.brightnessPopupOpen = false
        }
    }

    Timer {
        id: volumeCloseTimer

        interval: 250

        onTriggered: {
            bar.volumePopupOpen = false
        }
    }

    mask: Region {
        Region {
            item: leftBlock
        }

        Region {
            item: centerBlock
        }

        Region {
            item: rightBlock
        }

        Region {
            item: mediaEdge
        }

        Region {
            x: mediaPopup.x
            y: mediaPopup.y
            width: mediaPopup.width
            height: bar.mediaPopupOpen
                ? mediaPopup.height
                : 0
        }

        Region {
            x: brightnessPopup.x
            y: brightnessPopup.y
            width: brightnessPopup.width
            height: bar.brightnessPopupOpen
                ? brightnessPopup.height
                : 0
        }

        Region {
            x: volumePopup.x
            y: volumePopup.y
            width: volumePopup.width
            height: bar.volumePopupOpen
                ? volumePopup.height
                : 0
        }
    }

    Rectangle {
        id: leftBlock

        x: 8
        y: 4

        width: leftContent.implicitWidth + 20
        height: 32

        radius: 10
        color: Colors.md3.surface

        Row {
            id: leftContent

            anchors.centerIn: parent

            spacing: 10

            Text {
                width: 20
                height: 30

                text: "󰣇"

                color: Colors.md3.on_surface

                font.family: "JetBrainsMonoNL Nerd Font Mono"
                font.pixelSize: 22

                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                spacing: 0

                Repeater {
                    model: Hyprland.workspaces

                    delegate: Rectangle {
                        required property var modelData

                        width: 30
                        height: 30

                        radius: 5

                        color: modelData.active
                            ? Colors.md3.primary
                            : "transparent"

                        Text {
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

                            onClicked: {
                                modelData.activate()
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: centerBlock

        width: 500
        height: 32

        x: parent.width / 2 - width / 2
        y: 4

        radius: 10
        color: Colors.md3.surface

        Text {
            anchors.fill: parent

            anchors.leftMargin: 15
            anchors.rightMargin: 15

            text: Hyprland.activeToplevel
                ? Hyprland.activeToplevel.title
                : ""

            color: Colors.md3.on_surface

            font.family: "JetBrainsMonoNL Nerd Font Mono"
            font.bold: true
            font.pixelSize: 15

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            elide: Text.ElideRight
        }
    }

    Rectangle {
        id: rightBlock

        x: parent.width - width - 8
        y: 4

        width: rightContent.implicitWidth + 20
        height: 32

        radius: 10
        color: Colors.md3.surface

        Row {
            id: rightContent

            anchors.centerIn: parent

            spacing: 7

            Tray {
                window: bar
            }

            Brightness {
                id: brightness

                onHoveredChanged: {
                    if (hovered) {
                        mediaCloseTimer.stop()
                        volumeCloseTimer.stop()

                        bar.mediaPopupOpen = false
                        bar.volumePopupOpen = false
                        bar.brightnessPopupOpen = true
                    } else {
                        brightnessCloseTimer.restart()
                    }
                }
            }

            Volume {
                id: volume

                onHoveredChanged: {
                    if (hovered) {
                        mediaCloseTimer.stop()
                        brightnessCloseTimer.stop()

                        bar.mediaPopupOpen = false
                        bar.brightnessPopupOpen = false
                        bar.volumePopupOpen = true
                    } else {
                        volumeCloseTimer.restart()
                    }
                }
            }

            KeyboardLayout {}

            Clock {}
        }
    }

    Rectangle {
        id: mediaEdge

        x: 0
        y: 0

        width: 4
        height: bar.height

        color: "transparent"

        z: 20

        HoverHandler {
            onHoveredChanged: {
                if (hovered) {
                    mediaCloseTimer.stop()
                    bar.mediaPopupOpen = true
                } else {
                    mediaCloseTimer.restart()
                }
            }
        }
    }

    Rectangle {
        id: mediaPopup

        clip: true

        width: 360
        height: 150

        x: mediaPopupOpen ? 10 : -width
        y: screen.height / 4

        color: Colors.md3.surface
        radius: 10

        border.width: 2
        border.color: Colors.md3.primary

        Behavior on x {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        Media {
            anchors.fill: parent
            anchors.margins: 12
        }
    }

        Rectangle {
            id: brightnessPopup

            width: 140
            height: 38

            x: rightBlock.x
                + rightContent.x
                + brightness.x
                + brightness.width / 2
                - width / 2

            y: bar.brightnessPopupOpen
                ? 34
                : 18

            radius: 8

            color: Colors.md3.surface

            opacity: bar.brightnessPopupOpen ? 1 : 0
            scale: bar.brightnessPopupOpen ? 1 : 0.95

            z: 30

            Behavior on y {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 120
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 120
                    easing.type: Easing.OutCubic
                }
            }

            HoverHandler {
                onHoveredChanged: {
                    if (hovered) {
                        brightnessCloseTimer.stop()
                        bar.brightnessPopupOpen = true
                    } else {
                        brightnessCloseTimer.restart()
                    }
                }
            }

            Rectangle {
                id: brightnessSlider

                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter

                    leftMargin: 12
                    rightMargin: 12
                }

                height: 8
                radius: 4

                color: Colors.md3.surface_variant

                Rectangle {
                    width: brightnessSlider.width
                        * brightness.brightness
                        / 100

                    height: parent.height

                    radius: 4

                    color: Colors.md3.primary
                }

                Rectangle {
                    width: 16
                    height: 16

                    radius: 8

                    x: brightnessSlider.width
                        * brightness.brightness
                        / 100
                        - width / 2

                    anchors.verticalCenter: parent.verticalCenter

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

                    onPressed: {
                        brightness.setBrightnessValue(
                            mouseX / brightnessSlider.width * 100
                        )
                    }

                    onPositionChanged: {
                        if (pressed) {
                            brightness.setBrightnessValue(
                                mouseX / brightnessSlider.width * 100
                            )
                        }
                    }
                }
            }
    }

    Rectangle {
        id: volumePopup

        width: 140
        height: 38

        x: rightBlock.x
            + rightContent.x
            + volume.x
            + volume.width / 2
            - width / 2

        y: bar.volumePopupOpen
            ? 34
            : 18

        radius: 8

        color: Colors.md3.surface

        opacity: bar.volumePopupOpen ? 1 : 0
        scale: bar.volumePopupOpen ? 1 : 0.95

        z: 30

        Behavior on y {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 120
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }

        HoverHandler {
            onHoveredChanged: {
                if (hovered) {
                    volumeCloseTimer.stop()
                    bar.volumePopupOpen = true
                } else {
                    volumeCloseTimer.restart()
                }
            }
        }

        Rectangle {
            id: volumeSlider

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter

                leftMargin: 12
                rightMargin: 12
            }

            height: 8
            radius: 4

            color: Colors.md3.surface_variant

            Rectangle {
                width: volumeSlider.width
                    * volume.volume
                    / 100

                height: parent.height

                radius: 4

                color: Colors.md3.primary
            }

            Rectangle {
                width: 16
                height: 16

                radius: 8

                x: volumeSlider.width
                    * volume.volume
                    / 100
                    - width / 2

                anchors.verticalCenter: parent.verticalCenter

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

                onPressed: {
                    volume.setVolumeValue(
                        mouseX / volumeSlider.width * 100
                    )
                }

                onPositionChanged: {
                    if (pressed) {
                        volume.setVolumeValue(
                            mouseX / volumeSlider.width * 100
                        )
                    }
                }
            }
        }
    }
}
