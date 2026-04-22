import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    width: 200; height: 50
    Repeater {
        model: SystemTray.items
        delegate: Rectangle {
            Component.onCompleted: {
                console.log("Tray item properties:");
                for (var prop in modelData) {
                    console.log("  " + prop + ": " + modelData[prop]);
                }
            }
        }
    }
    Timer { interval: 1000; running: true; onTriggered: Qt.quit() }
}
