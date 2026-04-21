#!/bin/bash

echo "🌸 Instalando dependencias para el escritorio de MiaFate 🌸"
echo "----------------------------------------------------------"

# Verificar si yay está instalado (Asumimos que sí en base a tu .config)
if ! command -v yay &> /dev/null; then
    echo "❌ Error: 'yay' no está instalado. Por favor, instálalo primero."
    exit 1
fi

echo "📦 Instalando paquetes principales de Arch Linux y AUR..."

yay -S --needed --noconfirm \
    git \
    stow \
    hyprland \
    kitty \
    rofi-wayland \
    wlogout \
    swappy \
    swaync \
    eww \
    neovim \
    cava \
    fastfetch \
    neofetch \
    btop \
    wallust \
    ttf-jetbrains-mono-nerd \
    noto-fonts-cjk \
    xdg-desktop-portal-hyprland

echo "📦 Instalando herramientas especiales (Quickshell y Wallpaper Engine)..."
# Quickshell y linux-wallpaperengine están en AUR y pueden tardar un ratito en compilarse
yay -S --needed --noconfirm quickshell-git linux-wallpaperengine

echo "----------------------------------------------------------"
echo "✅ ¡Instalación completa!"
echo "Ahora puedes ejecutar 'stow desktop-quickshell' para restaurar tu configuración."
