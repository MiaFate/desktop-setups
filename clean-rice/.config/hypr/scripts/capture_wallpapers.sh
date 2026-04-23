#!/bin/bash

# --- Wallpaper Capture Script for Hyprland ---
# This script moves to empty workspaces on each monitor to capture the
# output of linux-wallpaperengine without windows obscuring it.

SNAPSHOT_DIR="$HOME/wallpapers/snapshots"
mkdir -p "$SNAPSHOT_DIR"

# Get current workspaces to restore them later
CURRENT_WS_1=$(hyprctl monitors -j | jq -r '.[] | select(.name == "DP-1") | .activeWorkspace.id')
CURRENT_WS_2=$(hyprctl monitors -j | jq -r '.[] | select(.name == "DP-2") | .activeWorkspace.id')

echo "🚀 Reiniciando Wallpaper Engine para la captura..."
# Usamos el comando exacto de tu config
linux-wallpaperengine --fps 24 --no-audio-processing --disable-particles --disable-mouse --silent --screen-root DP-1 --bg /home/mia/wallpapers/2503301542 --screen-root DP-2 --bg /home/mia/wallpapers/2587542891 &
WP_PID=$!

echo "🙈 Ocultando Quickshell (barras y reloj)..."
killall qs

echo "📸 Iniciando captura de fondos limpios..."

# Capture DP-1
echo "🖼️ Capturando DP-1 (fuerzo workspace 9)..."
hyprctl dispatch focusmonitor DP-1 > /dev/null
hyprctl dispatch workspace 9 > /dev/null
sleep 2 # Un poco más de tiempo para que cargue el motor
grim -o DP-1 "$SNAPSHOT_DIR/DP-1.png"

# Capture DP-2
echo "🖼️ Capturando DP-2 (fuerzo workspace 19)..."
hyprctl dispatch focusmonitor DP-2 > /dev/null
hyprctl dispatch workspace 19 > /dev/null
sleep 2
grim -o DP-2 "$SNAPSHOT_DIR/DP-2.png"

# Cleanup
echo "🧹 Limpiando procesos y restaurando interfaz..."
kill $WP_PID
qs &

# Restore workspaces
echo "🔄 Restaurando workspaces ($CURRENT_WS_1, $CURRENT_WS_2)..."
hyprctl dispatch focusmonitor DP-1 > /dev/null
hyprctl dispatch workspace "$CURRENT_WS_1" > /dev/null
hyprctl dispatch focusmonitor DP-2 > /dev/null
hyprctl dispatch workspace "$CURRENT_WS_2" > /dev/null

echo "✅ Capturas guardadas en $SNAPSHOT_DIR"
notify-send "Wallpaper Capture" "Snapshots guardadas en $SNAPSHOT_DIR"
