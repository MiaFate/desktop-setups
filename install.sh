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
    xdg-desktop-portal-hyprland \
    fcitx5 fcitx5-mozc fcitx5-im fcitx5-configtool \
    pamixer \
    bluez bluez-utils \
    playerctl \
    jq \
    power-profiles-daemon \
    networkmanager \
    python-requests \
    zsh \
    zsh-theme-powerlevel10k-git \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    zoxide

echo "📦 Instalando herramientas especiales (Quickshell y Wallpaper Engine)..."
# Quickshell y linux-wallpaperengine están en AUR y pueden tardar un ratito en compilarse
yay -S --needed --noconfirm quickshell-git linux-wallpaperengine

echo "🐚 Configurando Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "----------------------------------------------------------"
echo "✅ ¡Instalación completa!"
echo "Ahora puedes ejecutar 'stow desktop-quickshell' para restaurar tu configuración."
echo "IMPORTANTE: Recuerda cambiar tu shell a zsh con 'chsh -s $(which zsh)'"
