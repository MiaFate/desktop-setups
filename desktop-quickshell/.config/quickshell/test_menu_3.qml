import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Rectangle {
    width: 200; height: 50
    Repeater {
        model: SystemTray.items
        delegate: Rectangle {
            Component.onCompleted: {
                console.log(modelData.menu)
            }
        }
    }
    Timer { interval: 1000; running: true; onTriggered: Qt.quit() }
}
