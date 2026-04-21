import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    width: 200; height: 50
    Component.onCompleted: {
        console.log("Tray items:", SystemTray.items)
        Qt.quit()
    }
}
