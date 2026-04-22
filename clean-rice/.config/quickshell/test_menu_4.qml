import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    width: 200; height: 50
    Repeater {
        model: SystemTray.items
        delegate: Rectangle {
            Component.onCompleted: {
                if (modelData.menu) {
                    console.log("Menu properties:");
                    for (var prop in modelData.menu) {
                        console.log("  " + prop + ": " + typeof(modelData.menu[prop]));
                    }
                }
            }
        }
    }
    Timer { interval: 1000; running: true; onTriggered: Qt.quit() }
}
