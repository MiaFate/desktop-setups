import QtQuick
import Quickshell

Variants {
    model: Quickshell.screens
    PanelWindow {
        id: pw
        screen: modelData
        property bool isMainBar: pw.screen.name === "DP-1"
        Component.onCompleted: {
            console.log("Screen: " + pw.screen.name + " isMainBar: " + isMainBar)
        }
    }
}
