import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import "../../visualizer"
import "../themes"
import "root:/services/"

Item {
    id: miniVis
    implicitWidth: 40
    implicitHeight: 16
    
    property color color: Purpletheme.primary
    
    // Solo tomamos una pequeña muestra de los datos de Cava para ahorrar CPU
    readonly property var audioData: CavaService.audioData
    
    visible: CavaService.running && VisualizerSettings.enabled

    Row {
        anchors.fill: parent
        spacing: 2
        
        Repeater {
            // Solo 8 barras para la barra de tareas
            model: 8
            
            delegate: Rectangle {
                id: bar
                width: (parent.width - (7 * parent.spacing)) / 8
                
                // Mapeamos los datos de cava (usualmente 50+ barras) a nuestras 8
                // Tomamos índices salteados para cubrir bajos y medios
                readonly property int dataIndex: index * 4 
                
                height: Math.max(2, (miniVis.audioData[dataIndex] / 100) * miniVis.implicitHeight)
                anchors.bottom: parent.bottom
                radius: 1
                color: miniVis.color
                opacity: 0.8
                
                Behavior on height {
                    NumberAnimation { duration: 80; easing.type: Easing.OutQuad }
                }
            }
        }
    }
}
