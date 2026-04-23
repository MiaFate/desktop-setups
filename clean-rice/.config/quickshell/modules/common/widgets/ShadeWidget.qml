import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../themes"

RowLayout {
    id: root
    spacing: 12
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignHCenter

    property string currentShader: "none"

    function updateCurrent() {
        currentProc.running = true
    }

    function toggleShader(name) {
        if (name === "off") {
            execProc.command = ["hyprshade", "off"]
        } else {
            execProc.command = ["hyprshade", "toggle", name]
        }
        execProc.running = true
        // Pequeño delay para que hyprshade procese antes de preguntar el estado
        updateTimer.restart()
    }

    Timer {
        id: updateTimer
        interval: 100
        onTriggered: updateCurrent()
    }

    // Proceso para obtener el shader actual
    Process {
        id: currentProc
        command: ["hyprshade", "current"]
        stdout: SplitParser {
            onRead: data => {
                root.currentShader = data.trim() || "none"
            }
        }
    }

    Process { id: execProc }

    // Botones
    component ShadeButton : Rectangle {
        property string shaderName: ""
        property string icon: ""
        property string label: ""
        
        Layout.preferredWidth: 65
        Layout.preferredHeight: 45
        radius: 10
        color: root.currentShader === shaderName ? Purpletheme.primary : Purpletheme.bgAlt
        border.color: root.currentShader === shaderName ? "transparent" : Purpletheme.bgHover
        border.width: 1
        
        Behavior on color { ColorAnimation { duration: 200 } }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 2
            Text {
                text: icon
                font.pixelSize: 14
                Layout.alignment: Qt.AlignHCenter
                color: root.currentShader === shaderName ? "white" : Purpletheme.textPrimary
            }
            Text {
                text: label
                font.pixelSize: 9
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                color: root.currentShader === shaderName ? "white" : Purpletheme.textMuted
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.toggleShader(shaderName)
        }
    }

    ShadeButton {
        shaderName: "blue-light-filter"
        icon: "🌙"
        label: "Noche"
    }

    ShadeButton {
        shaderName: "grayscale"
        icon: "🌚"
        label: "Gris"
    }

    ShadeButton {
        shaderName: "vibrance"
        icon: "🌈"
        label: "Color"
    }

    ShadeButton {
        shaderName: "off"
        icon: "🚫"
        label: "Off"
        // Botón Off es especial, se ilumina si no hay nada activo
        color: root.currentShader === "none" || root.currentShader === "off" ? Purpletheme.textMuted : Purpletheme.bgAlt
    }

    Component.onCompleted: updateCurrent()
}
