pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    
    property bool spotifyPlaying: false
    
    // Monitoreamos Spotify usando playerctl
    Process {
        id: spotifyWatcher
        command: ["playerctl", "--follow", "-p", "spotify", "status"]
        running: true
        
        stdout: SplitParser {
            onRead: data => {
                var status = data.trim().toLowerCase()
                root.spotifyPlaying = (status === "playing")
            }
        }
        
        // Manejo de errores (si spotify se cierra)
        onExited: {
            root.spotifyPlaying = false
            // Intentar reiniciar el watcher después de un tiempo si spotify vuelve a aparecer
            recheckTimer.start()
        }
    }
    
    Timer {
        id: recheckTimer
        interval: 5000
        onTriggered: spotifyWatcher.running = true
    }
    
    // Check inicial y fallback si --follow falla
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            if (!spotifyWatcher.running) {
                var proc = Quickshell.createProcess(["playerctl", "-p", "spotify", "status"])
                proc.onExited = () => {
                   if (proc.exitCode === 0) {
                       spotifyWatcher.running = true
                   } else {
                       root.spotifyPlaying = false
                   }
                }
                proc.start()
            }
        }
    }
}
