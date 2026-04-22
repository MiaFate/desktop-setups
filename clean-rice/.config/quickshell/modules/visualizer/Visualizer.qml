import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../common/themes"

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

    
    // No queremos que bloquee el mouse (hacer click "atraviesa" el visualizador)
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    
    property var audioData: []
    
    // Proceso de Cava
    Process {
        id: cavaProc
        command: ["cava", "-p", Quickshell.shellDir + "/modules/visualizer/cava_config"]
        running: VisualizerSettings.enabled
        
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(';')
                var newData = []
                for (var i = 0; i < parts.length; i++) {
                    var val = parseInt(parts[i])
                    if (!isNaN(val)) newData.push(val)
                }
                if (newData.length > 0) {
                    visualizerWindow.audioData = newData
                    canvas.requestPaint()
                }
            }
        }
    }
    
    // Temporizador para limpiar datos si no hay música
    Timer {
        interval: 100
        running: VisualizerSettings.enabled
        repeat: true
        onTriggered: {
            // Si no recibimos datos nuevos, los bars bajan a 0
            canvas.requestPaint()
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        opacity: VisualizerSettings.enabled ? 0.6 : 0
        Behavior on opacity { NumberAnimation { duration: 500 } }
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            if (visualizerWindow.audioData.length === 0) return
            
            var w = width
            var h = height
            var bars = visualizerWindow.audioData
            var barWidth = w / bars.length
            
            if (VisualizerSettings.style === "bars") {
                var gradient = ctx.createLinearGradient(0, 0, 0, h)
                gradient.addColorStop(0, Purpletheme.primary)
                gradient.addColorStop(0.2, Purpletheme.primary)
                gradient.addColorStop(1, "transparent")
                ctx.fillStyle = gradient
                
                for (var i = 0; i < bars.length; i++) {
                    var barHeight = (bars[i] / 100) * h
                    ctx.fillRect(i * barWidth + 1, h - barHeight, barWidth - 2, barHeight)
                }
            } else if (VisualizerSettings.style === "waves") {
                // Style: Waves
                ctx.beginPath()
                ctx.lineWidth = 3
                ctx.strokeStyle = Purpletheme.primary
                
                ctx.moveTo(0, h)
                for (var i = 0; i < bars.length; i++) {
                    var barHeight = (bars[i] / 100) * h
                    ctx.lineTo(i * barWidth, h - barHeight)
                }
                ctx.lineTo(w, h)
                
                // Gradient fill
                var gradient = ctx.createLinearGradient(0, 0, 0, h)
                gradient.addColorStop(0, Purpletheme.primary)
                gradient.addColorStop(0.2, Purpletheme.primary)
                gradient.addColorStop(1, "transparent")
                ctx.fillStyle = gradient
                
                ctx.fill()
                ctx.stroke()
            } else if (VisualizerSettings.style === "cyber") {
                // Estilo Bloques Digitales
                var blockHeight = 4
                var spacing = 2
                
                for (var i = 0; i < bars.length; i++) {
                    var barHeight = (bars[i] / 100) * h
                    var numBlocks = Math.floor(barHeight / (blockHeight + spacing))
                    
                    for (var j = 0; j < numBlocks; j++) {
                        var y = h - (j * (blockHeight + spacing)) - blockHeight
                        // Desvanecimiento hacia abajo (más oscuro/transparente en la base)
                        var opacity = Math.min(1.0, (j / (numBlocks * 0.8)))
                        
                        ctx.fillStyle = Purpletheme.primary
                        ctx.globalAlpha = opacity
                        ctx.fillRect(i * barWidth + 1, y, barWidth - 2, blockHeight)
                    }
                    
                    // Pequeño pico flotante
                    if (numBlocks > 0) {
                        ctx.fillStyle = "white"
                        ctx.globalAlpha = 0.5
                        ctx.fillRect(i * barWidth + 1, h - (numBlocks + 2) * (blockHeight + spacing), barWidth - 2, 2)
                    }
                }
                ctx.globalAlpha = 1.0
            }
        }
    }
}
