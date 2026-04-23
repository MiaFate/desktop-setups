import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import "../common/themes"
import "root:/services/"
import "."

Item {
    id: root
    implicitHeight: 100
    Layout.fillWidth: true
    clip: true

    readonly property var audioData: CavaService.audioData

    // --- IMPLEMENTACIÓN OPTIMIZADA ---
    
    // Estilo 1: BARS (Rectángulos nativos - Ultra eficiente)
    Row {
        id: barsContainer
        anchors.fill: parent
        spacing: 1
        visible: VisualizerSettings.style === "bars"
        
        Repeater {
            model: root.audioData.length
            Rectangle {
                width: (barsContainer.width / root.audioData.length) - barsContainer.spacing
                height: (root.audioData[index] / 100) * barsContainer.height
                anchors.bottom: parent.bottom
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Purpletheme.primary }
                    GradientStop { position: 1.0; color: "transparent" }
                }
                Behavior on height { NumberAnimation { duration: 80; easing.type: Easing.OutQuad } }
            }
        }
    }

    // Estilo 2: WAVES (Shape)
    Shape {
        id: wavesVisualizer
        anchors.fill: parent
        visible: VisualizerSettings.style === "waves"
        
        ShapePath {
            strokeWidth: 2
            strokeColor: Purpletheme.primary
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            startX: 0
            startY: root.height
            PathPolyline {
                path: {
                    var data = root.audioData
                    var w = root.width
                    var h = root.height
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

    // Estilo 3: CYBER (Canvas optimizado)
    Canvas {
        id: complexVisualizer
        anchors.fill: parent
        visible: VisualizerSettings.style === "cyber"
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            var data = root.audioData
            if (data.length === 0) return
            
            var w = width
            var h = height
            var barWidth = w / data.length
            
            var blockH = 4
            var space = 1
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
            interval: 41
            running: complexVisualizer.visible
            repeat: true
            onTriggered: complexVisualizer.requestPaint()
        }
    }
}
