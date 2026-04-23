#!/bin/bash

# --- Wallpaper Capture Script for Hyprland (Improved) ---
# This script moves to empty workspaces on each monitor to capture the
# output of linux-wallpaperengine without windows obscuring it.

SNAPSHOT_DIR="$HOME/wallpapers/snapshots"
mkdir -p "$SNAPSHOT_DIR"

# Get current workspaces to restore them later
CURRENT_WS_1=$(hyprctl monitors -j | jq -r '.[] | select(.name == "DP-1") | .activeWorkspace.id')
CURRENT_WS_2=$(hyprctl monitors -j | jq -r '.[] | select(.name == "DP-2") | .activeWorkspace.id')

echo "🧹 Limpiando procesos previos..."
# Matamos Quickshell al instante para evitar que salga "velado" en la captura
pkill -9 qs
# Matamos cualquier instancia previa del motor para evitar solapamientos
pkill -9 -f linux-wallpaperengine
sleep 1

echo "🚀 Activando Wallpaper Engine para la captura..."
# Usamos el comando exacto de tu config
linux-wallpaperengine --fps 24 --no-audio-processing --disable-particles --disable-mouse --silent --screen-root DP-1 --bg /home/mia/wallpapers/2503301542 --screen-root DP-2 --bg /home/mia/wallpapers/2587542891 &
WP_PID=$!

# Forzamos opacidad 1.0 dinámicamente para evitar el efecto "velado"
sleep 1
hyprctl setprop "class:linux-wallpaperengine" opacity 1.0 1

echo "📸 Preparando captura de fondos limpios..."
# Esperamos 3 segundos (según lo pedido) para que el motor cargue y se asiente
sleep 3

# Capture DP-1
echo "🖼️ Capturando DP-1 (fuerzo workspace 9)..."
hyprctl dispatch focusmonitor DP-1 > /dev/null
hyprctl dispatch workspace 9 > /dev/null
hyprctl dispatch movecursor 3000 500
sleep 0.5
grim -o DP-1 "$SNAPSHOT_DIR/DP-1_temp.png"
echo "🪄 Escalando DP-1 a 5K con IA (Anime-Model)..."
realesrgan-ncnn-vulkan -i "$SNAPSHOT_DIR/DP-1_temp.png" -o "$SNAPSHOT_DIR/DP-1_5k.png" -s 2 -n realesr-animevideov3 > /dev/null 2>&1
echo "📉 Convirtiendo DP-1 de 5K a 4K para nitidez extrema..."
magick "$SNAPSHOT_DIR/DP-1_5k.png" -resize 3840x2160 "$SNAPSHOT_DIR/DP-1_4k.png"
rm "$SNAPSHOT_DIR/DP-1_temp.png"

# Capture DP-2
echo "🖼️ Capturando DP-2 (fuerzo workspace 19)..."
hyprctl dispatch focusmonitor DP-2 > /dev/null
hyprctl dispatch workspace 19 > /dev/null
hyprctl dispatch movecursor 500 500
sleep 0.5
grim -o DP-2 "$SNAPSHOT_DIR/DP-2_temp.png"
echo "🪄 Escalando DP-2 a 4K con IA (Anime-Model)..."
realesrgan-ncnn-vulkan -i "$SNAPSHOT_DIR/DP-2_temp.png" -o "$SNAPSHOT_DIR/DP-2_4k.png" -s 2 -n realesr-animevideov3 > /dev/null 2>&1
rm "$SNAPSHOT_DIR/DP-2_temp.png"

# Cleanup
echo "🧹 Restaurando interfaz..."
kill $WP_PID
# Esperamos un momento a que el proceso del motor se cierre
sleep 0.5
qs &

# Restore workspaces
echo "🔄 Restaurando workspaces ($CURRENT_WS_1, $CURRENT_WS_2)..."
hyprctl dispatch focusmonitor DP-1 > /dev/null
hyprctl dispatch workspace "$CURRENT_WS_1" > /dev/null
hyprctl dispatch focusmonitor DP-2 > /dev/null
hyprctl dispatch workspace "$CURRENT_WS_2" > /dev/null

# Devolvemos el cursor al centro de la pantalla principal
hyprctl dispatch movecursor 1280 720

echo "✅ Capturas guardadas en $SNAPSHOT_DIR"
notify-send "Wallpaper Capture" "Snapshots guardadas y limpias en $SNAPSHOT_DIR"
