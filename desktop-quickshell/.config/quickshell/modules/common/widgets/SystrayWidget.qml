import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "../themes"

Row {
    id: root
    Layout.alignment: Qt.AlignVCenter
    spacing: 8

    // Estado encapsulado del tooltip
    property string activeTooltipText: ""

    // Texto que muestra el nombre de la app (en lugar de un popup)
    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: root.activeTooltipText
        color: Purpletheme.textSecondary
        font.pixelSize: 12
        visible: text !== ""
    }

    Repeater {
        model: SystemTray.items
        delegate: Image {
            required property var modelData
            source: modelData.icon
            sourceSize.width: 16
            sourceSize.height: 16
            fillMode: Image.PreserveAspectFit
            
            QsMenuAnchor {
                id: menuAnchor
                menu: modelData.menu
            }

            MouseArea {
                id: trayMouseArea
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onEntered: {
                    if (modelData.title !== "") {
                        root.activeTooltipText = modelData.title
                    }
                }

                onExited: {
                    root.activeTooltipText = ""
                }
                
                onClicked: (mouse) => {
                    if (mouse.button === Qt.RightButton) {
                        if (modelData.hasMenu) {
                            menuAnchor.open() 
                        } else {
                            modelData.secondaryActivate()
                        }
                    } else {
                        modelData.activate()
                    }
                }
            }
        }
    }
}
