import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../themes"

Item {
    id: volumeWidget
    implicitWidth: mainRow.implicitWidth
    implicitHeight: 30

    property int volumeLevel: 0
    property bool volumeMuted: false
    property string audioSink: "speaker"
    property color customColor: Purpletheme.textPrimary
    
    // UI State
    property bool expanded: mouseHandler.containsMouse || mouseHandler.pressed

    property string volumeIcon: {
        if (volumeMuted) return "󰖁"
        if (audioSink === "headphone") return "󰋋"
        if (audioSink === "bluetooth") return "󰂰"
        if (audioSink === "hdmi") return "󰡁"
        if (volumeLevel < 30) return "󰕿"
        if (volumeLevel < 70) return "󰖀"
        return "󰕾"
    }

    // Dynamic color based on level
    property color levelColor: {
        if (volumeMuted) return Purpletheme.textMuted
        if (volumeLevel < 35) return "#94e2d5" // Teal
        if (volumeLevel < 75) return Purpletheme.primary // Purple
        return "#f5c2e7" // Magenta/Pink
    }

    Row {
        id: mainRow
        spacing: 8
        anchors.verticalCenter: parent.verticalCenter
        layoutDirection: Qt.RightToLeft // 👈 Esto invierte el orden del flujo

        // Icon and Percentage (Ahora es el ancla derecha)
        Text {
            id: volText
            anchors.verticalCenter: parent.verticalCenter
            text: volumeWidget.volumeIcon + " " + volumeWidget.volumeLevel + "%"
            color: volumeWidget.volumeMuted ? Purpletheme.textMuted : volumeWidget.customColor
            font.pixelSize: 14
            font.family: "Font Awesome 6 Free"
            font.bold: true
            
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        // The Smart Slider (Ahora se expande hacia la IZQUIERDA)
        Rectangle {
            id: sliderContainer
            anchors.verticalCenter: parent.verticalCenter
            
            width: volumeWidget.expanded ? 100 : 0
            clip: true
            height: 6
            radius: 3
            color: Purpletheme.bgHover
            opacity: volumeWidget.expanded ? 1.0 : 0.0

            Behavior on width { NumberAnimation { duration: 350; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 250 } }

            Rectangle {
                id: progressBar
                width: parent.width * (Math.min(Math.max(volumeWidget.volumeLevel, 0), 100) / 100)
                height: parent.height
                radius: 3
                color: volumeWidget.levelColor
                
                Behavior on color { ColorAnimation { duration: 300 } }
                Behavior on width { 
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad } 
                }
            }
        }
    }

    MouseArea {
        id: mouseHandler
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor
        
        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                volumeUpProc.running = true
            } else {
                volumeDownProc.running = true
            }
        }

        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton || mouse.button === Qt.MiddleButton) {
                muteToggleProc.running = true
            } else if (mouse.button === Qt.LeftButton) {
                // Ajuste de lógica para RightToLeft
                if (mouse.x < sliderContainer.width) {
                    var newVol = Math.round((mouse.x / sliderContainer.width) * 100)
                    setVolume(newVol)
                } else if (mouse.x > sliderContainer.width + mainRow.spacing) {
                    volumeControlProc.running = true // Pavucontrol
                }
            }
        }

        onPositionChanged: (mouse) => {
            if (pressed && mouse.button === Qt.LeftButton && volumeWidget.expanded) {
                if (mouse.x >= 0 && mouse.x <= sliderContainer.width) {
                    var newVol = Math.round((mouse.x / sliderContainer.width) * 100)
                    setVolume(newVol)
                }
            }
        }
    }

    function setVolume(val) {
        setVolProc.command = ["pamixer", "--set-volume", val.toString()]
        setVolProc.running = true
    }

    // --- PROCESSES ---

    Process {
        id: setVolProc
        onExited: volProc.running = true
    }

    Process {
        id: muteToggleProc
        command: ["pamixer", "-t"]
        onExited: volProc.running = true
    }

    Process {
        id: volProc
        command: ["pactl", "get-sink-volume", "@DEFAULT_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var match = data.match(/(\d+)%/)
                if (match) volumeWidget.volumeLevel = parseInt(match[1])
                
                // Get mute status
                checkMuteProc.running = true
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: checkMuteProc
        command: ["pactl", "get-sink-mute", "@DEFAULT_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                volumeWidget.volumeMuted = data.includes("Mute: yes")
            }
        }
    }

    Process {
        id: sinkProc
        command: ["pactl", "get-default-sink"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var sink = data.toLowerCase()
                if (sink.includes("headphone")) volumeWidget.audioSink = "headphone"
                else if (sink.includes("hdmi") || sink.includes("displayport")) volumeWidget.audioSink = "hdmi"
                else if (sink.includes("bluez")) volumeWidget.audioSink = "bluetooth"
                else volumeWidget.audioSink = "speaker"
            }
        }
        Component.onCompleted: running = true
    }

    Process { id: volumeUpProc; command: ["pamixer", "-i", "2"]; onExited: volProc.running = true }
    Process { id: volumeDownProc; command: ["pamixer", "-d", "2"]; onExited: volProc.running = true }
    Process { id: volumeControlProc; command: ["pavucontrol"] }

    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: {
            volProc.running = true
            sinkProc.running = true
        }
    }
}