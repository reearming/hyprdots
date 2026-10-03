import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Item {
    id: root

    property var window

    implicitWidth: trayRow.implicitWidth
    implicitHeight: 30

    Row {
        id: trayRow

        anchors.verticalCenter: parent.verticalCenter
        spacing: 13

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: trayItem

                required property var modelData

                width: 24
                height: 24

                IconImage {
                    anchors.fill: parent
                    source: modelData.icon
                }

                MouseArea {
                    anchors.fill: parent

                    acceptedButtons:
                        Qt.LeftButton | Qt.RightButton

                    onClicked: function(mouse) {
                        if (mouse.button === Qt.LeftButton) {
                            modelData.activate()
                        } else if (mouse.button === Qt.RightButton) {
                            if (modelData.hasMenu) {
                                const position =
                                    root.window.mapFromItem(
                                        trayItem,
                                        mouse.x,
                                        mouse.y
                                    )

                                modelData.display(
                                    root.window,
                                    position.x,
                                    position.y
                                )
                            } else {
                                modelData.secondaryActivate()
                            }
                        }
                    }
                }
            }
        }
    }
}
