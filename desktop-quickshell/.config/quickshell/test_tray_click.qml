import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    width: 200; height: 50
    Repeater {
        model: SystemTray.items
        delegate: Rectangle {
            width: 20; height: 20; color: "red"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Activating!");
                    try { modelData.activate(0, 0); console.log("Activated with 0,0"); } catch(e) { console.log(e); }
                }
            }
        }
    }
    Timer { interval: 3000; running: true; onTriggered: Qt.quit() }
}
