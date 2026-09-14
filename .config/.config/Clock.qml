import QtQuick

Item {
    id: root

    width: clockText.implicitWidth
    height: 30

    Text {
        id: clockText

        anchors.fill: parent

        color: Colors.md3.on_surface

        font.family: "JetBrainsMonoNL Nerd Font Mono"
        font.bold: true
        font.pixelSize: 15

        verticalAlignment: Text.AlignVCenter

        text: Qt.formatDateTime(
            new Date(),
            "dd MMM, HH:mm"
        )

        Timer {
            interval: 1000
            running: true
            repeat: true

            onTriggered: {
                clockText.text = Qt.formatDateTime(
                    new Date(),
                    "dd MMM, HH:mm"
                )
            }
        }
    }
}
