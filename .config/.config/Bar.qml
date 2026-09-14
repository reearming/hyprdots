//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

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

    property bool mediaPopupOpen: false
    property bool brightnessPopupOpen: false
    property bool volumePopupOpen: false

    Timer {
        id: mediaCloseTimer

        interval: 500

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
    }

    Rectangle {
        id: leftBlock

        x: 8
        y: 4

        width: leftContent.implicitWidth + 20
        height: 40

        radius: 10
        color: Colors.md3.surface

        border.width: 2
        border.color: Colors.md3.primary

        Row {
            id: leftContent

            anchors.centerIn: parent

            spacing: 10

            IconImage {
                width: 20
                height: 20

                source: "root:/assets/arch.svg"
            }

            Row {
                spacing: 5

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

                            text: modelData.id

                            color: modelData.active
                                ? Colors.md3.on_primary
                                : Colors.md3.on_surface

                            font.family: "JetBrainsMonoNL Nerd Font Mono"
                            font.pixelSize: 15
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                Hyprland.dispatch(
                                    "workspace " + modelData.id
                                )
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
        height: 40

        x: parent.width / 2 - width / 2
        y: 4

        radius: 10
        color: Colors.md3.surface

        border.width: 2
        border.color: Colors.md3.primary

        Text {
            id: windowTitle

            anchors.fill: parent

            anchors.leftMargin: 15
            anchors.rightMargin: 15

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            text: Hyprland.activeToplevel
                ? Hyprland.activeToplevel.title
                : ""

            color: Colors.md3.on_surface

            font.family: "JetBrainsMonoNL Nerd Font Mono"
            font.pixelSize: 15
            font.bold: true

            elide: Text.ElideRight
        }
    }

    Rectangle {
        id: rightBlock

        x: parent.width - width - 8
        y: 4

        width: rightContent.implicitWidth + 20
        height: 40

        radius: 10
        color: Colors.md3.surface

        border.width: 2
        border.color: Colors.md3.primary

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
                        brightnessCloseTimer.stop()

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
                        volumeCloseTimer.stop()

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

    PanelWindow {
        id: mediaTrigger

        anchors {
            top: true
            left: true
        }

        implicitWidth: 8
        implicitHeight: screen.height

        exclusiveZone: 0

        color: "transparent"

        mask: Region {
            item: mediaTriggerArea
        }

        Rectangle {
            id: mediaTriggerArea

            x: 0
            y: screen.height / 4 - 50

            width: 8
            height: 150

            color: "transparent"

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
    }

    PopupWindow {
        id: mediaPopup

        anchor.window: bar

        anchor.rect.x: 8
        anchor.rect.y: bar.screen.height / 4

        width: 360
        height: 150

        visible: bar.mediaPopupOpen

        color: "transparent"

        Rectangle {
            id: mediaPopupContent

            width: parent.width
            height: parent.height

            x: bar.mediaPopupOpen ? 0 : -width

            radius: 10
            color: Colors.md3.surface

            border.width: 2
            border.color: Colors.md3.primary

            clip: true

            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

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

            Media {
                anchors.fill: parent
                anchors.margins: 12
            }
        }
    }

    PopupWindow {
        id: brightnessPopup

        anchor.window: bar

        anchor.rect.x:
            rightBlock.x
            + brightness.x
            + brightness.width / 2
            - width / 2
            + 12

        anchor.rect.y:
            rightBlock.y + rightBlock.height

        width: 140
        height: 38

        visible: bar.brightnessPopupOpen

        color: "transparent"

        Rectangle {
            anchors.fill: parent

            radius: 8
            color: Colors.md3.surface

            border.width: 2
            border.color: Colors.md3.primary

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

                x: 12
                y: 15

                width: parent.width - 24
                height: 8

                radius: 4
                color: Colors.md3.surface_variant

                Rectangle {
                    width: parent.width * brightness.brightness / 100
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
                        brightness.setBrightnessValue(
                            Math.max(
                                0,
                                Math.min(
                                    100,
                                    mouseX / brightnessSlider.width * 100
                                )
                            )
                        )
                    }

                    onPositionChanged: {
                        if (pressed) {
                            brightness.setBrightnessValue(
                                Math.max(
                                    0,
                                    Math.min(
                                        100,
                                        mouseX / brightnessSlider.width * 100
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

                    x: brightnessSlider.width
                        * brightness.brightness / 100
                        - width / 2

                    anchors.verticalCenter: parent.verticalCenter

                    color: Colors.md3.primary
                }
            }
        }
    }

    PopupWindow {
        id: volumePopup

        anchor.window: bar

        anchor.rect.x:
            rightBlock.x
            + volume.x
            + volume.width / 2
            - width / 2
            + 12

        anchor.rect.y:
            rightBlock.y + rightBlock.height

        width: 140
        height: 38

        visible: bar.volumePopupOpen

        color: "transparent"

        Rectangle {
            anchors.fill: parent

            radius: 8
            color: Colors.md3.surface

            border.width: 2
            border.color: Colors.md3.primary

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

                x: 12
                y: 15

                width: parent.width - 24
                height: 8

                radius: 4
                color: Colors.md3.surface_variant

                Rectangle {
                    width: parent.width * volume.volume / 100
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
                        volume.setVolumeValue(
                            Math.max(
                                0,
                                Math.min(
                                    100,
                                    mouseX / volumeSlider.width * 100
                                )
                            )
                        )
                    }

                    onPositionChanged: {
                        if (pressed) {
                            volume.setVolumeValue(
                                Math.max(
                                    0,
                                    Math.min(
                                        100,
                                        mouseX / volumeSlider.width * 100
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

                    x: volumeSlider.width
                        * volume.volume / 100
                        - width / 2

                    anchors.verticalCenter: parent.verticalCenter

                    color: Colors.md3.primary
                }
            }
        }
    }
}
