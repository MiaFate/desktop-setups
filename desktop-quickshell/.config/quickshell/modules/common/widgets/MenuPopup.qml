import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../themes"
import "../../visualizer"

Rectangle {
    id: root
    implicitWidth: 350
    implicitHeight: 420
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: "Control Center"
            font.pixelSize: 18
            font.weight: Font.Bold
            color: Purpletheme.textPrimary
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Purpletheme.borderSoft
            opacity: 0.5
        }

        // Quick Settings Grid
        GridLayout {
            columns: 3
            columnSpacing: 20
            rowSpacing: 15
            
            // Visualizer Toggle
            ColumnLayout {
                spacing: 8
                Rectangle {
                    width: 55
                    height: 55
                    radius: 14
                    color: VisualizerSettings.enabled ? Purpletheme.active : Purpletheme.bgAlt
                    border.color: VisualizerSettings.enabled ? Purpletheme.primary : Purpletheme.borderSoft
                    border.width: 1
                    
                    Text {
                        anchors.centerIn: parent
                        text: "󰎆"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 26
                        color: VisualizerSettings.enabled ? "white" : Purpletheme.textMuted
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: VisualizerSettings.enabled = !VisualizerSettings.enabled
                    }
                }
                Text {
                    text: "Visualizer"
                    font.pixelSize: 10
                    font.bold: true
                    color: Purpletheme.textMuted
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Weather Placeholder
            ColumnLayout {
                spacing: 8
                Rectangle {
                    width: 55
                    height: 55
                    radius: 14
                    color: Purpletheme.bgAlt
                    border.color: Purpletheme.borderSoft
                    border.width: 1
                    
                    Text {
                        anchors.centerIn: parent
                        text: "󰖐"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 26
                        color: Purpletheme.textMuted
                    }
                }
                Text {
                    text: "Weather"
                    font.pixelSize: 10
                    font.bold: true
                    color: Purpletheme.textMuted
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // Spotify Section
        Text {
            text: "Now Playing"
            font.pixelSize: 12
            font.bold: true
            color: Purpletheme.textMuted
            Layout.topMargin: 10
        }

        SpotifyWidget {}
        
        Item { Layout.fillHeight: true }
        
        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "v1.0"
                font.pixelSize: 10
                color: Purpletheme.textMuted
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "Arch Linux"
                font.pixelSize: 12
                font.bold: true
                color: "#1793d1"
            }
        }
    }
}
