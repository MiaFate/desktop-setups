import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../themes"

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: clockWindow
        property var modelData
        screen: modelData

        // Ubicación idéntica a Eww (Bottom Left, 20px x 250px)
        anchors {
            bottom: true
            left: true
        }

        margins {
            left: 20 + (content.implicitWidth / 2)
            bottom: 250 + content.implicitHeight
        }

        WlrLayershell.layer: WlrLayer.Bottom
        WlrLayershell.namespace: "quickshell:desktop_clock"

        color: "transparent"

        property date now: new Date()
        implicitWidth: content.implicitWidth
        implicitHeight: content.implicitHeight

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockWindow.now = new Date()
        }

        ColumnLayout {
            id: content
            spacing: 0

            // Sección de la Hora
            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter

                Text {
                    text: Qt.formatDateTime(clockWindow.now, "hh")
                    font.pixelSize: 96
                    font.weight: Font.Bold
                    color: "#c4a7e7" // Color exacto de Eww
                }

                Text {
                    text: ":"
                    font.pixelSize: 96
                    font.weight: Font.Bold
                    color: "#c4a7e7"
                }

                Text {
                    text: Qt.formatDateTime(clockWindow.now, "mm")
                    font.pixelSize: 96
                    font.weight: Font.Bold
                    color: "#c4a7e7"
                }

                Text {
                    id: ampm
                    text: Qt.formatDateTime(clockWindow.now, "AP")
                    font.pixelSize: 32
                    font.weight: Font.Bold
                    color: "#c4a7e7"
                    Layout.alignment: Qt.AlignBottom
                    Layout.bottomMargin: 20
                }
            }

            // Sección de la Fecha
            RowLayout {
                spacing: 8
                Layout.alignment: Qt.AlignHCenter

                Text {
                    text: Qt.formatDateTime(clockWindow.now, "dddd, MMMM d")
                    font.pixelSize: 32
                    color: "#c4a7e7"
                    font.letterSpacing: 1
                }
            }
        }
    }
}
