import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import "../themes"
import "../../visualizer"

Rectangle {
    id: root
    implicitWidth: 360
    implicitHeight: 750
    color: "transparent"

    // Hyprshade Logic
    property string currentShader: "none"
    function updateShader() { currentShaderProc.running = true }
    function toggleShader(name) {
        execShaderProc.command = (name === "off") ? ["hyprshade", "off"] : ["hyprshade", "toggle", name]
        execShaderProc.running = true
        updateShaderTimer.restart()
    }
    Timer { id: updateShaderTimer; interval: 200; onTriggered: updateShader() }
    Process {
        id: currentShaderProc
        command: ["hyprshade", "current"]
        stdout: SplitParser { onRead: data => currentShader = data.trim() || "none" }
    }
    Process { id: execShaderProc }
    
    // Picker Logic
    Process { id: pickerProc; command: ["hyprpicker", "-a"] }
    
    // Shot Logic
    Process { id: shotProc }
    function takeShot(type) {
        if (type === "area") shotProc.command = ["hyprshot", "-m", "region"]
        else shotProc.command = ["hyprshot", "-m", "output"]
        shotProc.running = true
    }

    // Hypridle Logic
    property bool hypridleRunning: true
    function updateIdleStatus() { checkIdleProc.running = true }
    Process {
        id: checkIdleProc
        command: ["pgrep", "-x", "hypridle"]
        onExited: exitCode => {
            hypridleRunning = (exitCode === 0)
            console.log("Hypridle running status: " + hypridleRunning)
        }
    }
    Process { id: toggleIdleProc; command: ["/home/mia/.config/hypr/scripts/Hypridle.sh", "toggle"] }
    Timer { id: updateIdleStatusTimer; interval: 400; onTriggered: updateIdleStatus() }

    Component.onCompleted: {
        updateShader()
        updateIdleStatus()
    }

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
            columnSpacing: 25
            rowSpacing: 15
            Layout.alignment: Qt.AlignHCenter
            
            // Visualizer Toggle
            ColumnLayout {
                spacing: 8
                Rectangle {
                    width: 55; height: 55; radius: 14
                    color: VisualizerSettings.enabled ? Purpletheme.active : Purpletheme.bgAlt
                    border.color: VisualizerSettings.enabled ? Purpletheme.primary : Purpletheme.borderSoft
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "󰎆"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 26
                        color: VisualizerSettings.enabled ? "white" : Purpletheme.textMuted
                    }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: VisualizerSettings.enabled = !VisualizerSettings.enabled }
                }
                Text { text: "Visual"; font.pixelSize: 9; font.bold: true; color: Purpletheme.textMuted; Layout.alignment: Qt.AlignHCenter }
            }

            // Noche (Blue Light)
            ColumnLayout {
                spacing: 8
                Rectangle {
                    width: 55; height: 55; radius: 14
                    color: currentShader === "blue-light-filter" ? Purpletheme.active : Purpletheme.bgAlt
                    border.color: currentShader === "blue-light-filter" ? Purpletheme.primary : Purpletheme.borderSoft
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "󰖔"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 26
                        color: currentShader === "blue-light-filter" ? "white" : Purpletheme.textMuted
                    }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: toggleShader("blue-light-filter") }
                }
                Text { text: "Noche"; font.pixelSize: 9; font.bold: true; color: Purpletheme.textMuted; Layout.alignment: Qt.AlignHCenter }
            }

            // Grayscale
            ColumnLayout {
                spacing: 8
                Rectangle {
                    width: 55; height: 55; radius: 14
                    color: currentShader === "grayscale" ? Purpletheme.active : Purpletheme.bgAlt
                    border.color: currentShader === "grayscale" ? Purpletheme.primary : Purpletheme.borderSoft
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "󰔡"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 26
                        color: currentShader === "grayscale" ? "white" : Purpletheme.textMuted
                    }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: toggleShader("grayscale") }
                }
                Text { text: "Gris"; font.pixelSize: 9; font.bold: true; color: Purpletheme.textMuted; Layout.alignment: Qt.AlignHCenter }
            }

            // Color (Vibrance)
            ColumnLayout {
                spacing: 8
                Rectangle {
                    width: 55; height: 55; radius: 14
                    color: currentShader === "vibrance" ? Purpletheme.active : Purpletheme.bgAlt
                    border.color: currentShader === "vibrance" ? Purpletheme.primary : Purpletheme.borderSoft
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "󰏘"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 26
                        color: currentShader === "vibrance" ? "white" : Purpletheme.textMuted
                    }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: toggleShader("vibrance") }
                }
                Text { text: "Color"; font.pixelSize: 9; font.bold: true; color: Purpletheme.textMuted; Layout.alignment: Qt.AlignHCenter }
            }

            // Picker
            ColumnLayout {
                spacing: 8
                Rectangle {
                    width: 55; height: 55; radius: 14
                    color: Purpletheme.bgAlt
                    border.color: Purpletheme.borderSoft
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "󰈊"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 26
                        color: Purpletheme.textMuted
                    }
                    MouseArea { 
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            pickerProc.running = true
                            // Usamos el timer para cerrar después del click y evitar crashes
                            closeTimer.restart()
                        }
                    }
                }
                Text { text: "Picker"; font.pixelSize: 9; font.bold: true; color: Purpletheme.textMuted; Layout.alignment: Qt.AlignHCenter }
            }

            // ScreenShot
            ColumnLayout {
                spacing: 8
                Rectangle {
                    width: 55; height: 55; radius: 14
                    color: Purpletheme.bgAlt
                    border.color: Purpletheme.borderSoft
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "󰄀"; font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 26
                        color: Purpletheme.textMuted
                    }
                    MouseArea { 
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            closeTimer.restart()
                            takeShot("area")
                        }
                    }
                }
                Text { text: "Shot"; font.pixelSize: 9; font.bold: true; color: Purpletheme.textMuted; Layout.alignment: Qt.AlignHCenter }
            }

            // No Idle (Sleep Inhibit)
            ColumnLayout {
                spacing: 8
                Rectangle {
                    id: idleBtn
                    width: 55; height: 55; radius: 14
                    color: !hypridleRunning ? Purpletheme.active : Purpletheme.bgAlt
                    border.color: !hypridleRunning ? Purpletheme.primary : Purpletheme.borderSoft
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: !hypridleRunning ? "󰛊" : "󰖔" // Taza de café vs Luna
                        font.family: "JetBrainsMono Nerd Font"; font.pixelSize: 26
                        color: !hypridleRunning ? "white" : Purpletheme.textMuted
                    }
                    MouseArea { 
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            toggleIdleProc.running = true
                            hypridleRunning = !hypridleRunning // Cambio local instantáneo
                            updateIdleStatusTimer.restart() // Verificación por las dudas
                        }
                    }
                }
                Text { text: "No Idle"; font.pixelSize: 9; font.bold: true; color: Purpletheme.textMuted; Layout.alignment: Qt.AlignHCenter }
            }
        }

        // Timer de seguridad para cerrar el panel
        Timer {
            id: closeTimer
            interval: 100
            onTriggered: {
                // Intentamos cerrar de forma segura
                Hyprland.dispatch("dispatch focuswindow title:.*") // Esto suele forzar el cierre de popups de capa
            }
        }

        // Spotify Section
        Text {
            text: "Audio Visualizer"
            font.pixelSize: 12
            font.bold: true
            color: Purpletheme.textMuted
            Layout.topMargin: 10
        }

        Rectangle {
            Layout.fillWidth: true
            height: 80
            color: Purpletheme.bgAlt
            radius: 12
            border.color: Purpletheme.borderSoft
            clip: true
            
            VisualizerComponent {
                anchors.fill: parent
                anchors.margins: 10
            }
        }

        // Visualizer Styles
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            Repeater {
                model: ["bars", "waves", "cyber"]
                delegate: Rectangle {
                    Layout.fillWidth: true
                    height: 30
                    radius: 6
                    color: VisualizerSettings.style === modelData ? Purpletheme.active : Purpletheme.bgAlt
                    border.color: VisualizerSettings.style === modelData ? Purpletheme.primary : Purpletheme.borderSoft
                    
                    Text {
                        anchors.centerIn: parent
                        text: modelData.toUpperCase()
                        font.pixelSize: 9
                        font.bold: true
                        color: VisualizerSettings.style === modelData ? "white" : Purpletheme.textMuted
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: VisualizerSettings.style = modelData
                    }
                }
            }
        }

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
