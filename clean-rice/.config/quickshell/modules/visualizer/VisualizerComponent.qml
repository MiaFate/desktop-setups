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
    
    // Estilo 1: BARS (Shape)
    Shape {
        id: barsVisualizer
        anchors.fill: parent
        visible: VisualizerSettings.style === "bars"
        
        ShapePath {
            strokeColor: "transparent"
            fillGradient: LinearGradient {
                y1: 0; y2: barsVisualizer.height
                GradientStop { position: 0.0; color: Purpletheme.primary }
                GradientStop { position: 1.0; color: "transparent" }
            }
            
            startX: 0; startY: barsVisualizer.height
            
            PathPolyline {
                path: {
                    var data = root.audioData
                    var w = barsVisualizer.width
                    var h = barsVisualizer.height
                    var n = Math.max(1, data.length)
                    var spacing = 1
                    var barWidth = (w / n) - spacing
                    var points = []
                    
                    points.push(Qt.point(0, h))
                    for (var i = 0; i < data.length; i++) {
                        var x = i * (barWidth + spacing)
                        var val = (data[i] / 100) * h
                        points.push(Qt.point(x, h))
                        points.push(Qt.point(x, h - val))
                        points.push(Qt.point(x + barWidth, h - val))
                        points.push(Qt.point(x + barWidth, h))
                    }
                    points.push(Qt.point(w, h))
                    return points
                }
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

    // --- OPTIMIZACIÓN CYBER (Tiled Image) ---
    Canvas {
        id: cyberPattern
        width: 6; height: 6
        visible: false
        renderTarget: Canvas.Image
        property string patternUrl: ""
        onPaint: {
            var ctx = getContext("2d")
            ctx.fillStyle = Purpletheme.primary
            ctx.fillRect(0, 0, 6, 4) // Bloque de 4px y 2px de espacio
            patternUrl = toDataURL()
        }
        Component.onCompleted: requestPaint()
    }

    Row {
        id: cyberVisualizer
        anchors.fill: parent
        spacing: 1
        visible: VisualizerSettings.style === "cyber"
        
        Repeater {
            model: root.audioData.length
            Item {
                width: (cyberVisualizer.width / root.audioData.length) - cyberVisualizer.spacing
                height: (root.audioData[index] / 100) * cyberVisualizer.height
                anchors.bottom: parent.bottom
                clip: true
                
                Image {
                    anchors.fill: parent
                    source: cyberPattern.patternUrl
                    fillMode: Image.Tile
                    verticalAlignment: Image.AlignBottom
                }
                
                Behavior on height { 
                    enabled: root.visible
                    NumberAnimation { duration: 80; easing.type: Easing.OutQuad } 
                }
            }
        }
    }
}
