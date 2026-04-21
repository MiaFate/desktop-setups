import QtQuick
import QtQuick.Layouts
import "../../visualizer"
import "../themes"

DropdownWidget {
    id: visualizerWidget
    popupWidth: 180
    popupHeight: 120

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: VisualizerSettings.enabled ? "󱑽" : "󱑾"
        color: VisualizerSettings.enabled ? Purpletheme.textPrimary : Purpletheme.textMuted
        font.pixelSize: 16
        font.bold: true
    }

    popupContent: Component {
        Column {
            spacing: 12
            width: parent.width

            // Toggle Switch
            RowLayout {
                width: parent.width
                Text {
                    text: "Visualizer"
                    color: Purpletheme.textPrimary
                    Layout.fillWidth: true
                }
                Rectangle {
                    width: 40
                    height: 20
                    radius: 10
                    color: VisualizerSettings.enabled ? Purpletheme.inactive : Purpletheme.bgAlt
                    
                    Rectangle {
                        x: VisualizerSettings.enabled ? 22 : 2
                        y: 2
                        width: 16
                        height: 16
                        radius: 8
                        color: "white"
                        Behavior on x { NumberAnimation { duration: 150 } }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: VisualizerSettings.enabled = !VisualizerSettings.enabled
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Purpletheme.bgAlt }

            // Style Selector
            Column {
                spacing: 8
                width: parent.width
                
                Text { text: "Style:"; color: Purpletheme.textMuted; font.pixelSize: 10 }
                
                Row {
                    spacing: 10
                    width: parent.width
                    
                    // Bars Button
                    Rectangle {
                        width: (parent.width - 20) / 3
                        height: 30
                        radius: 4
                        color: VisualizerSettings.style === "bars" ? Purpletheme.inactive : Purpletheme.bgAlt
                        Text {
                            anchors.centerIn: parent
                            text: "Bars"
                            color: VisualizerSettings.style === "bars" ? "white" : Purpletheme.textPrimary
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: VisualizerSettings.style = "bars"
                        }
                    }
                    
                    // Waves Button
                    Rectangle {
                        width: (parent.width - 20) / 3
                        height: 30
                        radius: 4
                        color: VisualizerSettings.style === "waves" ? Purpletheme.inactive : Purpletheme.bgAlt
                        Text {
                            anchors.centerIn: parent
                            text: "Waves"
                            color: VisualizerSettings.style === "waves" ? "white" : Purpletheme.textPrimary
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: VisualizerSettings.style = "waves"
                        }
                    }

                    // Cyber Button
                    Rectangle {
                        width: (parent.width - 20) / 3
                        height: 30
                        radius: 4
                        color: VisualizerSettings.style === "cyber" ? Purpletheme.inactive : Purpletheme.bgAlt
                        Text {
                            anchors.centerIn: parent
                            text: "Cyber"
                            color: VisualizerSettings.style === "cyber" ? "white" : Purpletheme.textPrimary
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: VisualizerSettings.style = "cyber"
                        }
                    }
                }
            }
        }
    }
}
