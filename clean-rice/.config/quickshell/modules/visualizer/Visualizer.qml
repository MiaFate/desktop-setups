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
                    for (var i = 0; i < data.length; i++) {
                        points.push(Qt.point(i * barWidth, h - (data[i] / 100) * h))
                    }
                    points.push(Qt.point(w, h))
                    return points
                }
            }
        }
        
        // Efecto de brillo/relleno opcional
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
                    for (var i = 0; i < data.length; i++) {
                        points.push(Qt.point(i * barWidth, h - (data[i] / 100) * h))
                    }
                    points.push(Qt.point(w, h))
                    return points
                }
            }
        }
    }

    // Estilo 3: CYBER (Canvas - Sigue optimizado con un Timer más lento)
    Canvas {
        id: complexVisualizer
        anchors.fill: parent
        visible: VisualizerSettings.enabled && VisualizerSettings.style === "cyber"
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            var data = visualizerWindow.audioData
            if (data.length === 0) return
            
            var w = width
            var h = height
            var barWidth = w / data.length
            
            var blockH = 6
            var space = 2
            ctx.fillStyle = Purpletheme.primary
            for (var i = 0; i < data.length; i++) {
                var barH = (data[i] / 100) * h
                var blocks = Math.floor(barH / (blockH + space))
                for (var j = 0; j < blocks; j++) {
                    var y = h - (j * (blockH + space)) - blockH
                    ctx.globalAlpha = (j / blocks) * 0.8 + 0.2
                    ctx.fillRect(i * barWidth + 1, y, barWidth - 2, blockH)
                }
            }
            ctx.globalAlpha = 1.0
        }
        
        Timer {
            interval: 41 // ~24fps
            running: complexVisualizer.visible
            repeat: true
            onTriggered: complexVisualizer.requestPaint()
        }
    }
}
