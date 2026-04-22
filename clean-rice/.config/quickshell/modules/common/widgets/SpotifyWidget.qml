import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import "../themes"

Rectangle {
    id: root
    Layout.fillWidth: true
    implicitHeight: 140
    color: Purpletheme.bgAlt
    radius: 16
    border.color: Purpletheme.borderSoft
    border.width: 1

    property string title: "Not Playing"
    property string artist: ""
    property string artUrl: ""
    property double position: 0
    property double length: 0
    property string status: "Stopped"

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateMetadata()
    }

    function updateMetadata() {
        metaProc.running = true
        posProc.running = true
    }

    Process {
        id: metaProc
        command: ["playerctl", "-p", "spotify", "metadata", "--format", "{{title}}||{{artist}}||{{mpris:artUrl}}||{{mpris:length}}||{{status}}"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.split("||")
                if (parts.length >= 5) {
                    root.title = parts[0]
                    root.artist = parts[1]
                    root.artUrl = parts[2].replace("open.spotify.com", "i.scdn.co")
                    root.length = parseFloat(parts[3]) / 1000000
                    root.status = parts[4]
                }
            }
        }
    }

    Process {
        id: posProc
        command: ["playerctl", "-p", "spotify", "position"]
        stdout: SplitParser {
            onRead: data => {
                if (data) root.position = parseFloat(data)
            }
        }
    }

    function playPause() { cmdProc.command = ["playerctl", "-p", "spotify", "play-pause"]; cmdProc.running = true }
    function next() { cmdProc.command = ["playerctl", "-p", "spotify", "next"]; cmdProc.running = true }
    function prev() { cmdProc.command = ["playerctl", "-p", "spotify", "previous"]; cmdProc.running = true }
    Process { id: cmdProc }
    function focusSpotify() { focusProc.running = true }
    Process { id: focusProc; command: ["hyprctl", "dispatch", "focuswindow", "class:spotify"] }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 15

        // Album Art
        Rectangle {
            width: 100
            height: 100
            radius: 12
            clip: true
            color: Purpletheme.bgPopup
            
            Image {
                anchors.fill: parent
                source: root.artUrl || ""
                fillMode: Image.PreserveAspectCrop
                opacity: status === "Stopped" ? 0.3 : 1.0
                
                Text {
                    anchors.centerIn: parent
                    visible: !parent.source
                    text: "󰎆"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 32
                    color: Purpletheme.textMuted
                }
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: focusSpotify()
            }
        }

        // Info and Controls Area
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            // Metadata Area (Clickable to focus)
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                
                // TITLE MARQUEE
                Item {
                    Layout.fillWidth: true
                    height: 25
                    clip: true
                    
                    Text {
                        id: titleText
                        text: root.title
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 16
                        font.bold: true
                        color: Purpletheme.textPrimary
                        
                        readonly property bool needsMarquee: width > parent.width - 10
                        
                        SequentialAnimation on x {
                            running: titleText.needsMarquee
                            loops: Animation.Infinite
                            
                            PauseAnimation { duration: 2000 }
                            NumberAnimation {
                                from: 0
                                to: - (titleText.width - titleText.parent.width + 20)
                                duration: Math.max(3000, titleText.width * 20)
                                easing.type: Easing.InOutSine
                            }
                            PauseAnimation { duration: 2000 }
                            NumberAnimation {
                                to: 0
                                duration: 1000
                                easing.type: Easing.InOutSine
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: focusSpotify()
                    }
                }

                // ARTIST MARQUEE
                Item {
                    Layout.fillWidth: true
                    height: 18
                    clip: true
                    
                    Text {
                        id: artistText
                        text: root.artist
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                        color: Purpletheme.textMuted
                        
                        readonly property bool needsMarquee: width > parent.width - 10
                        
                        SequentialAnimation on x {
                            running: artistText.needsMarquee
                            loops: Animation.Infinite
                            
                            PauseAnimation { duration: 3000 }
                            NumberAnimation {
                                from: 0
                                to: - (artistText.width - artistText.parent.width + 20)
                                duration: Math.max(3000, artistText.width * 20)
                                easing.type: Easing.InOutSine
                            }
                            PauseAnimation { duration: 2000 }
                            NumberAnimation {
                                to: 0
                                duration: 1000
                                easing.type: Easing.InOutSine
                            }
                        }
                    }
                }
            }

            // Progress Bar
            Rectangle {
                Layout.fillWidth: true
                height: 4
                radius: 2
                color: Purpletheme.bgAlt
                
                Rectangle {
                    width: parent.width * (root.length > 0 ? (root.position / root.length) : 0)
                    height: parent.height
                    radius: 2
                    color: "#1793d1"
                }
            }

            // Controls
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 25
                
                Text {
                    text: "󰒮"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 22
                    color: Purpletheme.textPrimary
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: prev() }
                }

                Text {
                    text: root.status === "Playing" ? "󰏤" : "󰐊"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 30
                    color: Purpletheme.textPrimary
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: playPause() }
                }

                Text {
                    text: "󰒭"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 22
                    color: Purpletheme.textPrimary
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: next() }
                }
            }
        }
    }
}
