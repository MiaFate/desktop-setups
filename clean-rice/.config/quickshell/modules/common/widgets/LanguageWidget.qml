import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland
import "../themes"

RowLayout {
    id: root
    spacing: 8
    
    property string currentLang: "EN"
    property bool showFlag: false
    
    Timer {
        interval: 500 // Balance ideal: reactivo y ultra-bajo consumo
        running: true
        repeat: true
        onTriggered: updateLang()
    }
    
    function updateLang() {
        checkProc.running = true
    }
    
    function toggleLang() {
        // Rotamos los idiomas usando fcitx5-remote
        if (currentLang === "EN") {
            switchProc.command = ["fcitx5-remote", "-s", "mozc"]
        } else {
            switchProc.command = ["fcitx5-remote", "-s", "keyboard-us"]
        }
        switchProc.running = true
        
        // Forzamos actualización inmediata visual
        updateLang()
    }
    
    Timer {
        id: flagTimer
        interval: 2000 // Bajamos a 2s para que sea menos intrusivo
        onTriggered: showFlag = false
    }
    
    Process {
        id: checkProc
        command: ["fcitx5-remote", "-n"]
        stdout: SplitParser {
            onRead: data => {
                var oldLang = root.currentLang
                var cleanData = data.trim()
                
                if (cleanData.includes("mozc")) {
                    root.currentLang = "JP"
                } else {
                    root.currentLang = "EN"
                }
                
                // Si cambió el idioma, mostramos el feedback visual
                if (oldLang !== root.currentLang) {
                    showFlag = true
                    flagTimer.restart()
                }
            }
        }
    }
    
    Process { id: switchProc }
    
    GlobalShortcut {
        name: "langToggle"
        onPressed: toggleLang()
    }
    
    // La Banderita (Solo aparece al cambiar)
    Text {
        text: currentLang === "JP" ? "🇯🇵" : "🇺🇸"
        font.family: "Noto Color Emoji"
        font.pixelSize: 16
        visible: showFlag
        opacity: showFlag ? 1.0 : 0.0
        
        Behavior on opacity { NumberAnimation { duration: 300 } }
        
        Layout.alignment: Qt.AlignVCenter
    }

    // El Selector de Idioma
    Rectangle {
        Layout.preferredWidth: 45
        Layout.preferredHeight: 32
        radius: 8
        color: showFlag ? Purpletheme.active : "transparent"
        
        Behavior on color { ColorAnimation { duration: 300 } }
        
        Text {
            anchors.centerIn: parent
            text: currentLang === "JP" ? "あ" : "EN"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
            font.bold: true
            color: showFlag ? "white" : Purpletheme.textPrimary
        }
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: toggleLang()
            hoverEnabled: true
            onEntered: if(!showFlag) parent.color = Purpletheme.bgHover
            onExited: if(!showFlag) parent.color = "transparent"
        }
    }
}
