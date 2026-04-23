import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../themes"

DropdownWidget {
    id: powerWidget
    popupWidth: 140
    popupHeight: 165
    stemAlignment: "right"
    property color customColor: Purpletheme.textPrimary

    // Power actions
    Process {
        id: lockProc
        command: ["loginctl", "lock-session"]
    }

    Process {
        id: logoutProc
        command: ["hyprctl", "dispatch", "exit"]
    }

    Process {
        id: rebootProc
        command: ["systemctl", "reboot"]
    }

    Process {
        id: shutdownProc
        command: ["systemctl", "poweroff"]
    }

    // Icon with spacing
    // Icon
    Text {
        id: powerIcon
        text: "󰐥"
        color: dropdownOpen ? "#ff5555" : powerWidget.customColor
        font.pixelSize: 18
        font.family: "JetBrainsMono Nerd Font"
        width: 40
        height: 40
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    popupContent: Component {
        Column {
            spacing: 4

            // Lock
            Rectangle {
                width: parent.width
                height: 32
                color: lockMouse.containsMouse ? Qt.rgba(Purpletheme.colFg.r, Purpletheme.colFg.g, Purpletheme.colFg.b, 0.1) : "transparent"
                radius: 6

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    spacing: 10

                    Text {
                        text: "󰌾"
                        color: Purpletheme.colFg
                        font.pixelSize: Purpletheme.fontSize
                        font.family: Purpletheme.fontFamily
                    }
                    Text {
                        text: "Lock"
                        color: Purpletheme.colFg
                        font.pixelSize: Purpletheme.fontSize
                        font.family: Purpletheme.fontFamily
                    }
                }

                MouseArea {
                    id: lockMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        powerWidget.dropdownOpen = false
                        lockProc.running = true
                    }
                }
            }

            // Logout
            Rectangle {
                width: parent.width
                height: 32
                color: logoutMouse.containsMouse ? Qt.rgba(Purpletheme.colFg.r, Purpletheme.colFg.g, Purpletheme.colFg.b, 0.1) : "transparent"
                radius: 6

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    spacing: 10

                    Text {
                        text: "󰍃"
                        color: Purpletheme.colFg
                        font.pixelSize: Purpletheme.fontSize
                        font.family: Purpletheme.fontFamily
                    }
                    Text {
                        text: "Logout"
                        color: Purpletheme.colFg
                        font.pixelSize: Purpletheme.fontSize
                        font.family: Purpletheme.fontFamily
                    }
                }

                MouseArea {
                    id: logoutMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        powerWidget.dropdownOpen = false
                        logoutProc.running = true
                    }
                }
            }

            // Reboot
            Rectangle {
                width: parent.width
                height: 32
                color: rebootMouse.containsMouse ? Qt.rgba(Purpletheme.colFg.r, Purpletheme.colFg.g, Purpletheme.colFg.b, 0.1) : "transparent"
                radius: 6

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    spacing: 10

                    Text {
                        text: "󰜉"
                        color: "#ffb86c"
                        font.pixelSize: Purpletheme.fontSize
                        font.family: Purpletheme.fontFamily
                    }
                    Text {
                        text: "Reboot"
                        color: Purpletheme.colFg
                        font.pixelSize: Purpletheme.fontSize
                        font.family: Purpletheme.fontFamily
                    }
                }

                MouseArea {
                    id: rebootMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        powerWidget.dropdownOpen = false
                        rebootProc.running = true
                    }
                }
            }

            // Shutdown
            Rectangle {
                width: parent.width
                height: 32
                color: shutdownMouse.containsMouse ? Qt.rgba(Purpletheme.colFg.r, Purpletheme.colFg.g, Purpletheme.colFg.b, 0.1) : "transparent"
                radius: 6

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    spacing: 10

                    Text {
                        text: "󰐥"
                        color: "#ff5555"
                        font.pixelSize: Purpletheme.fontSize
                        font.family: Purpletheme.fontFamily
                    }
                    Text {
                        text: "Shutdown"
                        color: Purpletheme.colFg
                        font.pixelSize: Purpletheme.fontSize
                        font.family: Purpletheme.fontFamily
                    }
                }

                MouseArea {
                    id: shutdownMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        powerWidget.dropdownOpen = false
                        shutdownProc.running = true
                    }
                }
            }
        }
    }
}
