import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../themes"

Text {
    id: memWidget

    property int memUsage: 0

    text: memUsage + "% 󰾆"
    property color customColor: Purpletheme.textPrimary
    color: customColor
    font.pixelSize: Purpletheme.fontSize
    font.family: Purpletheme.fontFamily
    font.bold: true

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1
                var used = parseInt(parts[2]) || 0
                memWidget.memUsage = Math.round(100 * used / total)
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: memProc.running = true
    }
}
