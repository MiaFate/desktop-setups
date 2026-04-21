import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../themes"

DropdownWidget {
    id: btWidget
    popupWidth: 240
    popupHeight: Math.max(btDevices.length * 40 + 100, 150)
    popupXOffset: 280

    property bool btPowered: false
    property bool btConnected: false
    property string btConnectedDevice: ""
    property var btDevices: []

    onOpened: btDevicesProc.running = true

    // Bluetooth status check
    Process {
        id: btStatusProc
        property string output: ""
        command: ["sh", "-c", "bluetoothctl show | grep -E 'Powered|Name'"]
        stdout: SplitParser {
            onRead: data => {
                if (data) btStatusProc.output += data + "\n"
            }
        }
        onRunningChanged: {
            if (running) {
                output = ""
            } else if (output) {
                btWidget.btPowered = output.includes("Powered: yes")
            }
        }
        Component.onCompleted: running = true
    }

    // Bluetooth connected device check
    Process {
        id: btConnectedProc
        property string output: ""
        command: ["sh", "-c", "bluetoothctl info 2>/dev/null | grep -E 'Name|Connected' | head -2"]
        stdout: SplitParser {
            onRead: data => {
                if (data) btConnectedProc.output += data + "\n"
            }
        }
        onRunningChanged: {
            if (running) {
                output = ""
            } else {
                if (output.includes("Connected: yes")) {
                    btWidget.btConnected = true
                    var nameMatch = output.match(/Name:\s*(.+)/)
                    if (nameMatch) {
                        btWidget.btConnectedDevice = nameMatch[1].trim()
                    }
                } else {
                    btWidget.btConnected = false
                    btWidget.btConnectedDevice = ""
                }
            }
        }
        Component.onCompleted: running = true
    }

    // Bluetooth paired devices list
    Process {
        id: btDevicesProc
        property string output: ""
        command: ["sh", "-c", "bluetoothctl devices Paired"]
        stdout: SplitParser {
            onRead: data => {
                if (data) btDevicesProc.output += data + "\n"
            }
        }
        onRunningChanged: {
            if (running) {
                output = ""
            } else if (output) {
                var lines = output.trim().split('\n')
                var devices = []
                for (var i = 0; i < lines.length; i++) {
                    var match = lines[i].match(/Device\s+([0-9A-F:]+)\s+(.+)/)
                    if (match) {
                        devices.push({
                            mac: match[1],
                            name: match[2]
                        })
                    }
                }
                btWidget.btDevices = devices
            }
        }
        Component.onCompleted: running = true
    }

    // Bluetooth connect process
    Process {
        id: btConnectProc
        property string targetMAC: ""
        command: ["bluetoothctl", "connect", targetMAC]
    }

    // Bluetooth disconnect process
    Process {
        id: btDisconnectProc
        command: ["bluetoothctl", "disconnect"]
    }

    // Bluetooth power toggle
    Process {
        id: btPowerProc
        property bool powerOn: true
        command: ["bluetoothctl", "power", powerOn ? "on" : "off"]
    }

    // Update timer
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            btStatusProc.running = true
            btConnectedProc.running = true
        }
    }

    // Icon content
    Text {
        id: btText
        anchors.verticalCenter: parent.verticalCenter
        text: !btPowered ? "󰂲" :
              btConnected ? "󰂱" : "󰂯"
        color: !btPowered ? Purpletheme.textMuted :
               btConnected ? "#50fa7b" : Purpletheme.textPrimary
        font.pixelSize: 14
        font.family: "Font Awesome 6 Free"
        font.bold: true
    }

    // Popup content
    popupContent: Component {
        Column {
            spacing: 4

            // Header with power toggle
            RowLayout {
                width: parent.width
                spacing: 8

                Text {
                    text: btWidget.btPowered ? (btWidget.btConnected ? "󰂱 " + btWidget.btConnectedDevice : "󰂯 Bluetooth") : "󰂲 Bluetooth Off"
                    color: Purpletheme.textPrimary
                    font.pixelSize: 14
                    font.family: "Font Awesome 6 Free"
                    font.bold: true
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 40
                    height: 20
                    radius: 10
                    color: btWidget.btPowered ? Purpletheme.active : Purpletheme.textMuted

                    Rectangle {
                        width: 16
                        height: 16
                        radius: 8
                        color: Purpletheme.textPrimary
                        x: btWidget.btPowered ? parent.width - width - 2 : 2
                        anchors.verticalCenter: parent.verticalCenter

                        Behavior on x {
                            NumberAnimation { duration: 150 }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            btPowerProc.powerOn = !btWidget.btPowered
                            btPowerProc.running = true
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Purpletheme.textMuted
            }

            // Paired devices header
            Text {
                text: "Paired Devices"
                color: Purpletheme.textMuted
                font.pixelSize: 12
                font.family: "Font Awesome 6 Free"
                visible: btWidget.btPowered
            }

            // Device list
            ListView {
                id: btDeviceListView
                width: parent.width
                height: parent.height - 80
                clip: true
                model: btWidget.btDevices
                spacing: 2
                visible: btWidget.btPowered

                delegate: Rectangle {
                    width: btDeviceListView.width
                    height: 36
                    color: btMouseArea.containsMouse ? Qt.rgba(255, 255, 255, 0.1) : "transparent"
                    radius: 6

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 8

                        Text {
                            text: "󰂯"
                            color: Purpletheme.textPrimary
                            font.pixelSize: 14
                            font.family: "Font Awesome 6 Free"
                        }

                        Text {
                            text: modelData.name
                            color: modelData.name === btWidget.btConnectedDevice ? Purpletheme.textPrimary : Purpletheme.inactive
                            font.pixelSize: 13
                            font.family: "Font Awesome 6 Free"
                            font.bold: modelData.name === btWidget.btConnectedDevice
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        Text {
                            text: modelData.name === btWidget.btConnectedDevice ? "Connected" : ""
                            color: Purpletheme.textPrimary
                            font.pixelSize: 11
                            font.family: "Font Awesome 6 Free"
                        }
                    }

                    MouseArea {
                        id: btMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.name === btWidget.btConnectedDevice) {
                                btDisconnectProc.running = true
                            } else {
                                btConnectProc.targetMAC = modelData.mac
                                btConnectProc.running = true
                            }
                            btWidget.dropdownOpen = false
                        }
                    }
                }
            }

            // Empty state
            Text {
                text: btWidget.btPowered ? "No paired devices" : "Turn on Bluetooth to see devices"
                color: Purpletheme.textMuted
                font.pixelSize: 12
                font.family: "Font Awesome 6 Free"
                visible: btWidget.btDevices.length === 0
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}