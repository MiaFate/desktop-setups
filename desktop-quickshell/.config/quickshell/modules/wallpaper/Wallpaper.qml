import QtQuick
import Quickshell
import Quickshell.Wayland
import "../common/themes"

Item {
    id: root

    property color color1: Purpletheme.primary
    property color color2: Purpletheme.bgPopup
    
    Variants {
        model: Quickshell.screens

        delegate: PanelWindow {
            id: win
            property var modelData
            screen: modelData
            
            WlrLayershell.layer: WlrLayershell.Background
            WlrLayershell.namespace: "wallpaper"
            exclusionMode: Quickshell.None

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            Rectangle {
                anchors.fill: parent
                color: root.color2

                // Layer 1: Animating gradient
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 2
                    height: parent.height * 2
                    opacity: 0.4
                    radius: width / 2
                    gradient: Gradient {
                        orientation: Gradient.Vertical
                        GradientStop { position: 0.0; color: root.color1 }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                    
                    RotationAnimation on rotation {
                        from: 0; to: 360; duration: 30000; loops: Animation.Infinite
                    }
                }

                // Layer 2: Another animating gradient
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 2
                    height: parent.height * 2
                    opacity: 0.3
                    radius: width / 2
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 1.0; color: root.color1 }
                    }
                    
                    RotationAnimation on rotation {
                        from: 360; to: 0; duration: 45000; loops: Animation.Infinite
                    }
                }
                
                // Overlay for grain/texture
                Rectangle {
                    anchors.fill: parent
                    color: "black"
                    opacity: 0.05
                }
            }
        }
    }
}
