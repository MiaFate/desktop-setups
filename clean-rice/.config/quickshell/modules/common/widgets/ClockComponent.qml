import QtQuick
import QtQuick.Layouts
import "../themes"

RowLayout {
    spacing: 6
    property color customColor: Purpletheme.textPrimary

    Text {
        text: ""
        font.family: "Font Awesome 6 Free"
        font.pixelSize: 14
        color: customColor
    }

    Text {
        id: clock
        color: customColor
        font.pixelSize: 18
        font.weight: Font.Bold
        text: Qt.formatDateTime(new Date(), "hh:mm:AP")

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.text = Qt.formatDateTime(new Date(), "hh:mm:AP")
        }
    }
}