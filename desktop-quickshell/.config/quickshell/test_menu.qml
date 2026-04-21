import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Rectangle {
    width: 200; height: 50
    Repeater {
        model: SystemTray.items
        delegate: Rectangle {
            Component.onCompleted: console.log("Menu handle:", modelData.menu)
            // Try to create the menu
            QsMenu { id: menu; handle: modelData.menu }
        }
    }
}
