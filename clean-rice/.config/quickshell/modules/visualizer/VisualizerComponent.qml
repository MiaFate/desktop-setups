import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../common/themes"
import "."

Item {
    id: root
    implicitHeight: 100
    Layout.fillWidth: true
    clip: true

    property var audioData: []
    
    Process {
        id: cavaProc
        command: ["cava", "-p", Quickshell.shellDir + "/modules/visualizer/cava_config"]
        running: root.visible // Siempre activo si el panel es visible
        
        stdout: SplitParser {
            onRead: data => {
                var parts = data.trim().split(';')
                var newData = []
                for (var i = 0; i < parts.length; i++) {
                    var val = parseInt(parts[i])
                    if (!isNaN(val)) newData.push(val)
                }
                if (newData.length > 0) {
                    root.audioData = newData
                    canvas.requestPaint()
                }
            }
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        opacity: 1.0
        Behavior on opacity { NumberAnimation { duration: 500 } }
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            if (root.audioData.length === 0) return
            
            var w = width
            var h = height
            var bars = root.audioData
            var barWidth = w / bars.length
            
            if (VisualizerSettings.style === "bars") {
                var gradient = ctx.createLinearGradient(0, 0, 0, h)
                gradient.addColorStop(0, Purpletheme.primary)
                gradient.addColorStop(1, "transparent")
                ctx.fillStyle = gradient
                
                for (var i = 0; i < bars.length; i++) {
                    var barHeight = (bars[i] / 100) * h
                    ctx.fillRect(i * barWidth + 1, h - barHeight, barWidth - 2, barHeight)
                }
            } else if (VisualizerSettings.style === "waves") {
                ctx.beginPath()
                ctx.lineWidth = 2
                ctx.strokeStyle = Purpletheme.primary
                ctx.moveTo(0, h)
                for (var i = 0; i < bars.length; i++) {
                    var barHeight = (bars[i] / 100) * h
                    ctx.lineTo(i * barWidth, h - barHeight)
                }
                ctx.lineTo(w, h)
                ctx.stroke()
            } else if (VisualizerSettings.style === "cyber") {
                var blockHeight = 3
                var spacing = 1
                for (var i = 0; i < bars.length; i++) {
                    var barHeight = (bars[i] / 100) * h
                    var numBlocks = Math.floor(barHeight / (blockHeight + spacing))
                    for (var j = 0; j < numBlocks; j++) {
                        var y = h - (j * (blockHeight + spacing)) - blockHeight
                        ctx.fillStyle = Purpletheme.primary
                        ctx.globalAlpha = Math.min(1.0, (j / (numBlocks * 0.8)))
                        ctx.fillRect(i * barWidth + 1, y, barWidth - 2, blockHeight)
                    }
                }
                ctx.globalAlpha = 1.0
            }
        }
    }
}
