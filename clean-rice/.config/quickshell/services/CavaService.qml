pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../modules/visualizer"

Singleton {
    id: root
    property var audioData: []
    
    Process {
        id: cavaProc
        command: ["cava", "-p", Quickshell.shellDir + "/modules/visualizer/cava_config"]
        // Se ejecuta si el visualizador está habilitado globalmente
        // Nota: Agregamos una condición extra para asegurar que no se quede colgado si qs se recarga
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
                    root.audioData = newData
                }
            }
        }
    }
}
