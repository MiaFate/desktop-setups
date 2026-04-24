import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import "../common/themes"
import "../common/widgets"
import "root:/services/"
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Variants {
    id: barVariants
    model: Quickshell.screens

    PanelWindow {
        id: bar
        property var modelData
        screen: modelData

        property bool isMainBar: bar.modelData.name === "DP-1"
        property color barTextColor: isMainBar ? Purpletheme.textPrimary : "#94e2d5"
        
        signal closeAllPopups()
        
        color: "transparent"
        visible: true
        
        anchors { top: true; left: true; right: true }
        margins { top: 4 }
        implicitHeight: isMainBar ? 56 : 41

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell:bar"

        Rectangle {
            anchors.fill: parent
            anchors.margins: 6
            radius: 6
            color: isMainBar ? "#1e1e2eff" : '#1e13e2ff'
            border.color: isMainBar ? Purpletheme.borderStrong : '#5c13e2bf'
            border.width: 2
        }

        // --- CONTENEDOR PRINCIPAL ---
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 18
            anchors.rightMargin: 12
            spacing: 0

            // 1. BLOQUE IZQUIERDA (Agrupado y Dinámico)
            RowLayout {
                spacing: 12
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.fillHeight: true
                
                DropdownWidget {
                    id: menuDropdown
                    barWindow: bar
                    popupWidth: 360; popupHeight: 750
                    stemAlignment: "left"
                    MenuWidget {}
                    popupContent: Component { MenuPopup {} }
                }

                UpdateWidget { Layout.alignment: Qt.AlignVCenter }

                // --- WORKSPACES CON ICONOS (Restaurados) ---
                Row {
                    visible: isMainBar
                    spacing: 6
                    
                    Repeater {
                        model: Hyprland.workspaces
                        delegate: Rectangle {
                            id: workspaceRect
                            required property var modelData
                            implicitWidth: workspaceInnerRow.implicitWidth + 20
                            implicitHeight: 30
                            radius: 6
                            color: modelData.active ? Purpletheme.active : Purpletheme.inactive

                            Row {
                                id: workspaceInnerRow
                                anchors.centerIn: parent
                                spacing: 6

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: modelData.id
                                    font.pixelSize: 14; font.bold: true
                                    color: Purpletheme.textPrimary
                                }

                                // Iconos de aplicaciones en el workspace
                                Repeater {
                                    model: {
                                        var windows = HyprlandData.windowList.filter(win => win.workspace.id === modelData.id);
                                        var groups = {};
                                        windows.forEach(win => {
                                            if (!groups[win.class]) groups[win.class] = { className: win.class, count: 0 };
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
                                            implicitWidth: 18; implicitHeight: 18
                                        }
                                        Text {
                                            visible: modelData.count > 1
                                            text: "x" + modelData.count
                                            font.pixelSize: 10; font.bold: true; color: Purpletheme.textPrimary
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

                WindowInfo {
                    visible: isMainBar
                    Layout.preferredWidth: 250
                }
            }

            // 2. ESPACIADOR (Empuja a los extremos)
            Item { Layout.fillWidth: true }

            // 3. BLOQUE DERECHA (Tu orden exacto)
            RowLayout {
                id: statusArea
                spacing: 12
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                SystrayWidget { 
                    visible: !isMainBar 
                    Layout.alignment: Qt.AlignVCenter
                }

                // 🔊 Volumen (Expande a la izquierda)
                VolumeComponent {
                    Layout.alignment: Qt.AlignVCenter
                    customColor: bar.barTextColor
                }

                // 🎵 MiniVisualizer
                MiniVisualizer {
                    Layout.alignment: Qt.AlignVCenter
                    color: bar.barTextColor
                }

                // ⌨️ Layout / Idioma
                LanguageWidget {
                    Layout.alignment: Qt.AlignVCenter
                    customColor: bar.barTextColor
                }

                // 🕒 Reloj con Popup
                DropdownWidget {
                    barWindow: bar
                    popupWidth: 500; popupHeight: 380
                    stemAlignment: "right"
                    Layout.alignment: Qt.AlignVCenter
                    ClockComponent {
                        customColor: bar.barTextColor
                    }
                    popupContent: Component { DashboardPopup {} }
                }

                // 🔋 Power (Ancla Final)
                PowerWidget {
                    barWindow: bar
                    Layout.alignment: Qt.AlignVCenter
                    customColor: bar.barTextColor
                }
            }
        }

        // --- 4. CENTRO ABSOLUTO (Independiente) ---
        CenterInfo {
            id: absoluteCenter
            visible: isMainBar
            barWindow: bar
            anchors.centerIn: parent
        }

        // Overlay para cerrar popups al tocar el fondo de la barra
        MouseArea {
            anchors.fill: parent
            z: -1 // Enviar al fondo para no interceptar clics de widgets
            onClicked: bar.closeAllPopups()
        }
    }
}