import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../themes"

Rectangle {
    id: root
    
    // Dimensiones fijas para que siempre esté ahí
    Layout.preferredWidth: 45
    Layout.preferredHeight: 32
    Layout.alignment: Qt.AlignVCenter
    
    width: Layout.preferredWidth
    height: Layout.preferredHeight
    
    color: "transparent"
    visible: true // Siempre visible

    property int updateCount: 0
    
    Timer {
        interval: 600000 
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: checkUpdates()
    }
    
    function checkUpdates() {
        checkProc.running = true
    }
    
    Process {
        id: checkProc
        command: ["sh", "-c", "yay -Qu 2>/dev/null | wc -l"]
        stdout: SplitParser {
            onRead: data => {
                var count = parseInt(data.toString().trim())
                if (!isNaN(count)) root.updateCount = count
            }
        }
    }
    
    // El botón visual interno
    Rectangle {
        anchors.fill: parent
        anchors.margins: 2
        radius: 8
        color: Purpletheme.bgHover
        
        RowLayout {
            anchors.centerIn: parent
            spacing: 6
            
            // Contenedor para el Pacman y el puntito
            Item {
                width: 20
                height: 20
                
                Text {
                    anchors.centerIn: parent
                    text: "󰮯"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                    color: root.updateCount > 0 ? "#f9e2af" : Purpletheme.textMuted
                }
                
                // El puntito de "comida"
                Rectangle {
                    visible: root.updateCount > 0
                    width: 4
                    height: 4
                    radius: 2
                    color: "#f9e2af"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: -2
                }
            }
            
            Text {
                text: root.updateCount
                font.pixelSize: 12
                font.bold: true
                color: Purpletheme.textPrimary
                visible: root.updateCount > 0
            }
        }
    }

    // MouseArea ocupando TODO el rectángulo raíz
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: {
            console.log("Update button CLICKED!");
            updateExec.command = ["hyprctl", "dispatch", "exec", "/home/mia/.config/hypr/scripts/Distro_update.sh"]
            updateExec.running = true
            refreshTimer.start()
        }
    }

    Process { id: updateExec }
    
    Timer {
        id: refreshTimer
        interval: 10000 
        onTriggered: checkUpdates()
    }
}
