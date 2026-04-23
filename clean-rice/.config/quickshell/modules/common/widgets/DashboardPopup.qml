import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../themes"

Rectangle {
    id: root
    implicitWidth: 480
    implicitHeight: 320
    color: "transparent"

    property var currentTime: new Date()

    // Helper component for circular stats
    component StatCircle : Item {
        id: statRoot
        property string label: ""
        property int value: 0
        property color strokeColor: Purpletheme.primary
        
        implicitWidth: 65
        implicitHeight: 80

        onValueChanged: canvas.requestPaint()
        
        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            
            Item {
                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
                Layout.alignment: Qt.AlignHCenter
                
                Canvas {
                    id: canvas
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        
                        var cx = width / 2
                        var cy = height / 2
                        var r = (width / 2) - 4
                        
                        // Background track
                        ctx.beginPath()
                        ctx.lineWidth = 4
                        ctx.strokeStyle = Purpletheme.bgAlt
                        ctx.arc(cx, cy, r, 0, 2 * Math.PI)
                        ctx.stroke()
                        
                        // Progress arc
                        ctx.beginPath()
                        ctx.lineWidth = 4
                        ctx.lineCap = "round"
                        ctx.strokeStyle = strokeColor
                        var angle = (statRoot.value / 100) * 2 * Math.PI
                        ctx.arc(cx, cy, r, -Math.PI/2, angle - Math.PI/2)
                        ctx.stroke()
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: statRoot.value + "%"
                        font.pixelSize: 11
                        font.bold: true
                        color: Purpletheme.textPrimary
                    }
                }
            }
            
            Text {
                text: label
                Layout.alignment: Qt.AlignHCenter
                font.pixelSize: 10
                font.bold: true
                color: Purpletheme.textMuted
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 20

        // LEFT: Vertical Clock
        ColumnLayout {
            Layout.preferredWidth: 100
            spacing: 12 // Espacio real entre la hora y los detalles
            Layout.alignment: Qt.AlignVCenter
            
            // Hours and Minutes Block
            ColumnLayout {
                spacing: -22
                Layout.alignment: Qt.AlignHCenter
                Text {
                    text: Qt.formatDateTime(root.currentTime, "hh")
                    font.pixelSize: 68
                    font.weight: Font.Black
                    color: Purpletheme.textPrimary
                    lineHeight: 0.8
                }
                Text {
                    text: Qt.formatDateTime(root.currentTime, "mm")
                    font.pixelSize: 68
                    font.weight: Font.Black
                    color: Purpletheme.textPrimary
                    lineHeight: 0.8
                }
            }
            
            // Seconds and Date Block
            ColumnLayout {
                spacing: 2
                Layout.alignment: Qt.AlignHCenter
                Text {
                    text: Qt.formatDateTime(root.currentTime, "ss")
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                    color: Purpletheme.primary
                }
                Text {
                    text: Qt.formatDateTime(root.currentTime, "ddd, dd MMM")
                    font.pixelSize: 11
                    font.bold: true
                    color: Purpletheme.textMuted
                }
            }
        }

        // DIVIDER
        Rectangle {
            Layout.fillHeight: true
            width: 1
            color: "#94e2d5"
            opacity: 0.8
        }

        // RIGHT: Stats & Calendar
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 15

            // Stats row
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                spacing: 15
                
                StatCircle { 
                    label: "CPU"
                    value: cpuStat.cpuUsage
                    strokeColor: Purpletheme.primary
                }
                StatCircle { 
                    label: "RAM"
                    value: memStat.memUsage
                    strokeColor: "#f5c2e7"
                }
                StatCircle { 
                    label: "BAT"
                    value: batStat.batteryLevel
                    strokeColor: "#94e2d5"
                }
            }

            // Calendar Row
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 5
                
                Text {
                    text: Qt.formatDateTime(root.currentTime, "MMMM yyyy")
                    font.bold: true
                    font.pixelSize: 14
                    color: Purpletheme.primary
                    Layout.alignment: Qt.AlignHCenter
                }

                DayOfWeekRow {
                    locale: Qt.locale()
                    Layout.fillWidth: true
                    delegate: Text {
                        text: model.shortName
                        color: Purpletheme.textMuted
                        font.pixelSize: 10
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                MonthGrid {
                    id: grid
                    month: new Date().getMonth()
                    year: new Date().getFullYear()
                    Layout.fillWidth: true
                    
                    delegate: Text {
                        text: model.day
                        color: model.month === grid.month ? Purpletheme.textPrimary : Purpletheme.textMuted
                        font.pixelSize: 11
                        font.bold: model.today
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: -2
                            color: Purpletheme.primary
                            visible: model.today
                            opacity: 0.3
                            radius: 4
                            z: -1
                        }
                    }
                }
            }
        }
    }

    // Background listeners for data
    CpuWidget { id: cpuStat; visible: false }
    MemoryWidget { id: memStat; visible: false }
    BatteryWidget { id: batStat; visible: false }
    
    // Auto-update timer for clock
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            root.currentTime = new Date()
        }
    }
}
