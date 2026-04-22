import QtQuick
import Quickshell

ShellRoot {
    Component.onCompleted: {
        console.log("Quickshell properties:")
        for (var prop in Quickshell) {
            console.log(prop + ": " + Quickshell[prop])
        }
        Qt.quit()
    }
}
