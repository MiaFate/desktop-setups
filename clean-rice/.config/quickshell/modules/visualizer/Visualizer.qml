import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../common/themes"
import QtQuick.Shapes
import "root:/services/"

PanelWindow {
    id: visualizerWindow
    
    screen: Quickshell.screens[0]
    
    // Configuración de la ventana
    anchors {
        bottom: true
        left: true
        right: true
    }
    
    margins {
        bottom: 5
        left: 10
        right: 10
    }
    
    implicitHeight: screen.height / 5
    color: "transparent"
    
    // Capa de fondo
    WlrLayershell.layer: WlrLayer.Bottom
    WlrLayershell.namespace: "quickshell:visualizer"
    WlrLayershell.exclusiveZone: 0
    
    // No queremos que bloquee el mouse
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    
    // El proceso de Cava ahora se gestiona en CavaService.qml
    readonly property var audioData: CavaService.audioData
    
    // --- IMPLEMENTACIÓN OPTIMIZADA ---
    
    // Estilo 1: BARS (Rectángulos nativos - Ultra eficiente)
    Row {
        id: barsContainer
        anchors.fill: parent
        anchors.margins: 2
        spacing: 1
        visible: VisualizerSettings.enabled && VisualizerSettings.style === "bars"
        
        Repeater {
            model: visualizerWindow.audioData.length
            Rectangle {
                width: (barsContainer.width / visualizerWindow.audioData.length) - barsContainer.spacing
                height: (visualizerWindow.audioData[index] / 100) * barsContainer.height
                anchors.bottom: parent.bottom
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Purpletheme.primary }
                    GradientStop { position: 1.0; color: "transparent" }
                }
                Behavior on height { NumberAnimation { duration: 80; easing.type: Easing.OutQuad } }
            }
        }
    }

    // Estilo 2: WAVES (Shape - Mucho más eficiente que Canvas)
    Shape {
        id: wavesVisualizer
        anchors.fill: parent
        visible: VisualizerSettings.enabled && VisualizerSettings.style === "waves"
        
        ShapePath {
            id: wavePath
            strokeWidth: 3
            strokeColor: Purpletheme.primary
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            
            startX: 0
            startY: visualizerWindow.height
            
            PathPolyline {
                path: {
                    var data = visualizerWindow.audioData
                    var w = visualizerWindow.width
                    var h = visualizerWindow.height
                    var barWidth = w / Math.max(1, data.length)
                    var points = []
                    // Asegurar anclaje a la base al inicio
                    points.push(Qt.point(0, h))
                    for (var i = 0; i < data.length; i++) {
                        points.push(Qt.point(i * barWidth, h - (data[i] / 100) * h))
                    }
                    // Asegurar anclaje a la base al final
                    points.push(Qt.point(w, h))
                    return points
                }
            }
        }
        
        // Efecto de brillo/relleno
        ShapePath {
            fillGradient: LinearGradient {
                y1: 0; y2: wavesVisualizer.height
                GradientStop { position: 0.0; color: Purpletheme.primary }
                GradientStop { position: 1.0; color: "transparent" }
            }
            strokeColor: "transparent"
            startX: 0
            startY: visualizerWindow.height
            PathPolyline {
                path: {
                    var data = visualizerWindow.audioData
                    var w = visualizerWindow.width
                    var h = visualizerWindow.height
                    var barWidth = w / Math.max(1, data.length)
                    var points = []
                    points.push(Qt.point(0, h))
                    for (var i = 0; i < data.length; i++) {
                        points.push(Qt.point(i * barWidth, h - (data[i] / 100) * h))
                    }
                    points.push(Qt.point(w, h))
                    return points
                }
            }
        }
    }

    // --- OPTIMIZACIÓN CYBER (Tiled Image - Super eficiente en Qt 6) ---
    // Generamos un bloque patrón una sola vez
    Canvas {
        id: cyberPattern
        width: 10; height: 10
        visible: false
        renderTarget: Canvas.Image
        property string patternUrl: ""
        onPaint: {
            var ctx = getContext("2d")
            ctx.fillStyle = Purpletheme.primary
            ctx.fillRect(0, 0, 10, 7) // Bloque de 7px y 3px de espacio
            patternUrl = toDataURL()
        }
        Component.onCompleted: requestPaint()
    }

    Row {
        id: cyberVisualizer
        anchors.fill: parent
        anchors.margins: 2
        spacing: 2
        visible: VisualizerSettings.enabled && VisualizerSettings.style === "cyber"
        
        Repeater {
            model: visualizerWindow.audioData.length
            Item {
                width: (cyberVisualizer.width / visualizerWindow.audioData.length) - cyberVisualizer.spacing
                height: (visualizerWindow.audioData[index] / 100) * cyberVisualizer.height
                anchors.bottom: parent.bottom
                clip: true
                
                Image {
                    anchors.fill: parent
                    source: cyberPattern.patternUrl
                    fillMode: Image.Tile
                    verticalAlignment: Image.AlignBottom
                }
                
                Behavior on height { NumberAnimation { duration: 80; easing.type: Easing.OutQuad } }
            }
        }
    }
}
