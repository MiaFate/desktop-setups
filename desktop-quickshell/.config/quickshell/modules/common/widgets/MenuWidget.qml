import QtQuick
import QtQuick.Layouts
import "../themes"

Item {
    id: root
    width: 26
    height: 32
    
    Text {
        id: icon
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 2
        text: ""
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 22
        color: "#1793d1" // Arch Linux Color
        
        Behavior on color { ColorAnimation { duration: 200 } }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: icon.color = Qt.lighter("#1793d1", 1.2)
        onExited: icon.color = "#1793d1"
        // onClicked lo manejará el DropdownWidget en Bar.qml
    }
}
