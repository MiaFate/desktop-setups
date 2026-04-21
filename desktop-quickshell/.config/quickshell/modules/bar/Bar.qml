import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland   // 👈 MUY IMPORTANTE
import Quickshell.Io
import "../common/themes"
import "../common/widgets"
import "root:/services/"
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Variants {
    id: barVariants

    // 💡 TIPO DE MONITOR:
    // Para ver en TODOS los monitores usa: Quickshell.screens
    // Para ver SOLO en el principal usa: [Quickshell.screens[0]]
    model: Quickshell.screens

    PanelWindow {
        id: bar
        property var modelData
        screen: modelData

    signal closeAllPopups()

    // Identificación de Monitores
    property bool isMainBar: bar.modelData.name === "DP-1"
    property bool isSecondaryBar: !isMainBar

    // Listen to Hyprland events to close popups when focus changes
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            // Close popups when active window changes or layer closes
            if (event.name === "activewindow" || event.name === "activewindowv2") {
                bar.closeAllPopups()
            }
        }
    }

     color: isMainBar ? "transparent" : '#c4636266'
    //color: '#c42b1c5f'
    // Barra siempre visible
    visible: true

    // Posición tipo top bar
    anchors {
        top: true
        left: true
        right: true
    }
    
    margins {
        top: 4
    }

    implicitHeight: isMainBar ? 50 : 35

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell:bar"

    Rectangle {
        anchors.fill: parent
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        anchors.leftMargin: 6
        anchors.rightMargin: 6
        radius: 6
        color: isMainBar ? "#1e1e2ecc" : '#1e13e2c0'

        border.color: isMainBar ? Purpletheme.borderStrong : '#5c13e2bf'
        border.width: 2
    }

    RowLayout {
        anchors.fill: parent
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        anchors.leftMargin: 14
        anchors.rightMargin: 8
        spacing: 8

        //  Menu
        DropdownWidget {
            id: menuDropdown
            barWindow: bar
            popupWidth: 350
            popupHeight: 450
            stemAlignment: "left"
            Layout.alignment: Qt.AlignVCenter
            MenuWidget {}

            popupContent: MenuPopup {}

            GlobalShortcut {
                name: "menuToggle"
                onPressed: {
                    // Usamos el nombre del monitor para mayor precisión
                    if (Hyprland.focusedMonitor.name === bar.modelData.name) {
                        menuDropdown.dropdownOpen = !menuDropdown.dropdownOpen
                    }
                }
            }
        }

        // 󰚰 Updates (En todas las barras para probar)
        UpdateWidget {
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: -4
        }

        // 🖥️ Workspaces
        Row {
            visible: isMainBar
            spacing: 4
            
            Repeater {
                model: Hyprland.workspaces

                delegate: Rectangle {
                    id: workspaceRect
                    required property var modelData

                    implicitWidth: workspaceRow.implicitWidth + 20
                    implicitHeight: 30
                    radius: 6

                    color: modelData.active ? Purpletheme.active : Purpletheme.inactive

                    Row {
                        id: workspaceRow
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.id
                            font.pixelSize: 14
                            font.bold: true
                            color: Purpletheme.textPrimary
                        }

                        Repeater {
                            model: {
                                var windows = HyprlandData.windowList.filter(win => win.workspace.id === modelData.id);
                                var groups = {};
                                windows.forEach(win => {
                                    if (!groups[win.class]) {
                                        groups[win.class] = { className: win.class, count: 0 };
                                    }
                                    groups[win.class].count++;
                                });
                                return Object.values(groups);
                            }
                            
                            delegate: Row {
                                spacing: 2
                                anchors.verticalCenter: parent.verticalCenter
                                required property var modelData

                                IconImage {
                                    anchors.verticalCenter: parent.verticalCenter
                                    source: Quickshell.iconPath(AppSearch.guessIcon(modelData.className), "image-missing")
                                    implicitWidth: 18
                                    implicitHeight: 18
                                }

                                Text {
                                    visible: modelData.count > 1
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "x" + modelData.count
                                    font.pixelSize: 10
                                    font.bold: true
                                    color: Purpletheme.textPrimary
                                }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("workspace " + modelData.id)
                    }
                }
            }
        }

        // Window Info
        WindowInfo {
            visible: isMainBar
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignVCenter
        }

        // Left Spacer
        Item {
            Layout.fillWidth: true
        }

        // Center Info
        CenterInfo {
            visible: isMainBar
            barWindow: bar
            Layout.alignment: Qt.AlignVCenter
        }

        // Right Spacer
        Item {
            visible: isMainBar
            Layout.fillWidth: true
        }

        RowLayout {
            id: statusArea
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.rightMargin: 12
            spacing: 12

            SystrayWidget { visible: isSecondaryBar }

            CpuWidget { visible: isSecondaryBar }
            MemoryWidget { visible: isSecondaryBar }

            // Separator visual
            Text {
                visible: isSecondaryBar
                text: "|"
                color: Purpletheme.colMuted
                font.pixelSize: 14
            }

            LanguageWidget {
                Layout.alignment: Qt.AlignVCenter
            }

            WifiWidget {
                barWindow: bar
            }

            BluetoothWidget {
                barWindow: bar
            }
            
            PowerProfileWidget {
                barWindow: bar
            }

            VisualizerWidget {
                barWindow: bar
            }

            VolumeComponent {
                Layout.alignment: Qt.AlignVCenter
            }

            DropdownWidget {
                barWindow: bar
                popupWidth: 500
                popupHeight: 350
                stemAlignment: "right"
                ClockComponent {}
                popupContent: DashboardPopup {}
            }

            PowerWidget {
                barWindow: bar
            }
        }
    }

    // Click overlay to close popups - sits on top but propagates clicks
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onClicked: (mouse) => {
            bar.closeAllPopups()
            mouse.accepted = false
        }
    }
}
}