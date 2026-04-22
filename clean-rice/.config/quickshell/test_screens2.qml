import QtQuick
import Quickshell

Variants {
    model: Quickshell.screens
    PanelWindow {
        property var modelData
        screen: modelData
        Component.onCompleted: console.log("Screen: " + modelData.name)
    }
}
