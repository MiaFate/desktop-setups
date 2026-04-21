import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../themes"

Item {
    id: volumeWidget
    implicitWidth: mainRow.implicitWidth
    implicitHeight: mainRow.implicitHeight

    property int volumeLevel: 0
    property bool volumeMuted: false
    property string audioSink: "speaker"  // speaker, headphone, hdmi, bluetooth

    property string volumeIcon: {
        if (volumeMuted) return "󰖁"
        if (audioSink === "headphone") return "󰋋"
        if (audioSink === "bluetooth") return "󰂰"
        if (audioSink === "hdmi") return "󰡁"
        // Speaker icons based on volume
        if (volumeLevel < 30) return "󰕿"
        if (volumeLevel < 70) return "󰖀"
        return "󰕾"
    }

    Row {
        id: mainRow
        spacing: 12
        anchors.fill: parent

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: volumeWidget.volumeIcon + " " + volumeWidget.volumeLevel + "%"
            color: volumeWidget.volumeMuted ? Purpletheme.textMuted :
                   volumeWidget.audioSink === "headphone" ? "#f1fa8c" :
                   volumeWidget.audioSink === "bluetooth" ? Purpletheme.active :
                   Purpletheme.textPrimary
            font.pixelSize: 14
            font.family: "Font Awesome 6 Free"
            font.bold: true
        }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 60
            height: 6
            radius: 3
            color: Purpletheme.colMuted
            opacity: 0.5

            Rectangle {
                width: parent.width * (Math.min(Math.max(volumeWidget.volumeLevel, 0), 100) / 100)
                height: parent.height
                radius: 3
                color: volumeWidget.volumeMuted ? Purpletheme.textMuted : Purpletheme.primary
                
                Behavior on width {
                    NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: volumeControlProc.running = true
        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                volumeUpProc.running = true
            } else {
                volumeDownProc.running = true
            }
        }
    }

    // Volume level (pactl for PulseAudio)
    Process {
        id: volProc
        command: ["pactl", "get-sink-volume", "@DEFAULT_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var match = data.match(/(\d+)%/)
                if (match) {
                    volumeWidget.volumeLevel = parseInt(match[1])
                }
                volumeWidget.volumeMuted = data.includes("Mute: yes")
            }
        }
        Component.onCompleted: running = true
    }

    // Audio sink type detection
    Process {
        id: sinkProc
        command: ["pactl", "get-default-sink"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var sink = data.toLowerCase()
                if (sink.includes("headphone") || sink.includes("headset")) {
                    volumeWidget.audioSink = "headphone"
                } else if (sink.includes("hdmi") || sink.includes("displayport")) {
                    volumeWidget.audioSink = "hdmi"
                } else if (sink.includes("bluez") || sink.includes("bluetooth")) {
                    volumeWidget.audioSink = "bluetooth"
                } else {
                    volumeWidget.audioSink = "speaker"
                }
            }
        }
        Component.onCompleted: running = true
    }

    // Volume up
    Process {
        id: volumeUpProc
        command: ["pamixer", "-i", "5"]
        onExited: volProc.running = true
    }

    // Volume down
    Process {
        id: volumeDownProc
        command: ["pamixer", "-d", "5"]
        onExited: volProc.running = true
    }

    // Volume control launcher
    Process {
        id: volumeControlProc
        command: ["pavucontrol"]
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            volProc.running = true
            sinkProc.running = true
        }
    }
}