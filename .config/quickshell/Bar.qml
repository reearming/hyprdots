import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 100
    exclusiveZone: 40
    color: "transparent"

    property bool brightnessPopupOpen: false
    property bool volumePopupOpen: false

    mask: Region {
        Region {
            item: barBackground
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
        id: barBackground

        width: parent.width
        height: 40

        color: Colors.md3.surface
        radius: 10

        z: 2

        Text {
            anchors {
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }

            text: "󰣇"

            color: Colors.md3.on_surface

            font.family: "JetBrainsMonoNL Nerd Font Mono"
            font.pixelSize: 40

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Row {
            id: workspaces

            anchors {
                left: parent.left
                leftMargin: 40
                verticalCenter: parent.verticalCenter
            }

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

                        onClicked: modelData.activate()
                    }
                }
            }
        }

        Media {
            id: media

            anchors {
                left: workspaces.right
                leftMargin: 20
                verticalCenter: parent.verticalCenter
            }
        }

        Item {
            id: titleContainer

            anchors.centerIn: parent

            width: 500
            height: 30

            clip: true

            Text {
                id: titleText

                height: parent.height

                text: {
                    const title = Hyprland.activeToplevel
                        ? Hyprland.activeToplevel.title
                        : ""

                    return title
                }

                color: Colors.md3.on_surface

                font.family: "JetBrainsMonoNL Nerd Font Mono"
                font.bold: true
                font.pixelSize: 15

                verticalAlignment: Text.AlignVCenter

                x: {
                    if (implicitWidth <= parent.width)
                        return (parent.width - implicitWidth) / 2

                    const range = implicitWidth - parent.width

                    return -range * (marqueeProgress / 100)
                }

                property real marqueeProgress: 0

                SequentialAnimation on marqueeProgress {
                    id: marqueeAnimation

                    running: titleText.implicitWidth > titleText.parent.width

                    loops: Animation.Infinite

                    PauseAnimation {
                        duration: 1200
                    }

                    NumberAnimation {
                        from: 0
                        to: 100

                        duration: Math.max(
                            3000,
                            titleText.implicitWidth * 35
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
                            titleText.implicitWidth * 15
                        )

                        easing.type: Easing.InOutCubic
                    }

                    PauseAnimation {
                        duration: 800
                    }

                    onRunningChanged: {
                        if (!running)
                            titleText.marqueeProgress = 0
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

        Row {
            id: rightSide

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 10
            }

            spacing: 5

            Tray {
                window: bar
            }

            Item {
                width: 2
                height: 1
            }

            Brightness {
                id: brightness
            }

            Connections {
                target: brightness

                function onHoveredChanged() {
                    if (brightness.hovered) {
                        brightnessCloseTimer.stop()

                        bar.volumePopupOpen = false
                        bar.brightnessPopupOpen = true
                    } else {
                        brightnessCloseTimer.restart()
                    }
                }
            }

            Volume {
                id: volume
            }

            Connections {
                target: volume

                function onHoveredChanged() {
                    if (volume.hovered) {
                        volumeCloseTimer.stop()

                        bar.brightnessPopupOpen = false
                        bar.volumePopupOpen = true
                    } else {
                        volumeCloseTimer.restart()
                    }
                }
            }

            Item {
                width: 2
                height: 1
            }

            KeyboardLayout {}

            Item {
                width: 7
                height: 1
            }

            Clock {}
        }
    }

    Timer {
        id: brightnessCloseTimer

        interval: 250
        repeat: false

        onTriggered: {
            if (!brightness.hovered &&
                !brightnessPopupHover.hovered) {
                bar.brightnessPopupOpen = false
            }
        }
    }

    Timer {
        id: volumeCloseTimer

        interval: 250
        repeat: false

        onTriggered: {
            if (!volume.hovered &&
                !volumePopupHover.hovered) {
                bar.volumePopupOpen = false
            }
        }
    }

    Rectangle {
        id: brightnessPopup

        width: 140
        height: 38

        x: rightSide.x
            + brightness.x
            + brightness.width / 2
            - width / 2

        y: bar.brightnessPopupOpen ? 34 : 18

        radius: 8

        color: Colors.md3.surface

        opacity: bar.brightnessPopupOpen ? 1 : 0
        scale: bar.brightnessPopupOpen ? 1 : 0.85

        transformOrigin: Item.Top

        z: 1

        Behavior on y {
            NumberAnimation {
                duration: 180
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
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        HoverHandler {
            id: brightnessPopupHover

            enabled: bar.brightnessPopupOpen

            onHoveredChanged: {
                if (hovered) {
                    brightnessCloseTimer.stop()
                } else if (!brightness.hovered) {
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

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

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

                hoverEnabled: true

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

        x: rightSide.x
            + volume.x
            + volume.width / 2
            - width / 2

        y: bar.volumePopupOpen ? 34 : 18

        radius: 8

        color: Colors.md3.surface

        opacity: bar.volumePopupOpen ? 1 : 0
        scale: bar.volumePopupOpen ? 1 : 0.85

        transformOrigin: Item.Top

        z: 1

        Behavior on y {
            NumberAnimation {
                duration: 180
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
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        HoverHandler {
            id: volumePopupHover

            enabled: bar.volumePopupOpen

            onHoveredChanged: {
                if (hovered) {
                    volumeCloseTimer.stop()
                } else if (!volume.hovered) {
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

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

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

                hoverEnabled: true

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
