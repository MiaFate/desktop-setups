import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    width: 200; height: 50
    SystemTray { id: tray }
    Component.onCompleted: {
        console.log("Tray valid?", tray !== null)
        Qt.quit()
    }
}
