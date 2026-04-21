import QtQuick
import Quickshell

Variants {
    model: Quickshell.screens
    PanelWindow {
        screen: modelData
        Component.onCompleted: console.log("Screen: " + modelData.name)
    }
}
