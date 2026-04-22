import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    width: 200; height: 50
    Repeater {
        model: SystemTray.items
        delegate: Rectangle {
            width: 20; height: 20
            QsMenuAnchor {
                id: menuAnchor
                menu: modelData.menu
            }
            MouseArea {
                anchors.fill: parent
                onClicked: menuAnchor.open()
            }
        }
    }
}
