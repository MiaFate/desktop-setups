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
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateLang()
    }
    
    function updateLang() {
        checkProc.running = true
    }
    
    function toggleLang() {
        if (currentLang === "EN") {
            switchProc.command = ["fcitx5-remote", "-s", "mozc"]
        } else {
            switchProc.command = ["fcitx5-remote", "-s", "keyboard-us"]
        }
        switchProc.running = true
        showFlag = true
        flagTimer.restart()
    }
    
    Timer {
        id: flagTimer
        interval: 3000
        onTriggered: showFlag = false
    }
    
    Process {
        id: checkProc
        command: ["fcitx5-remote", "-n"]
        stdout: SplitParser {
            onRead: data => {
                var oldLang = root.currentLang
                if (data.includes("mozc")) {
                    root.currentLang = "JP"
                } else {
                    root.currentLang = "EN"
                }
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
