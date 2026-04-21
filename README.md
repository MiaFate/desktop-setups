# Mia's Hyprland & Quickshell Dotfiles 🌸

Este repositorio contiene toda la configuración de mi entorno de escritorio basado en Arch Linux, Hyprland y Quickshell. Está gestionado con **GNU Stow**, lo que hace que reinstalarlo o recuperarlo sea súper fácil.

## 🛠️ Requisitos Previos

Antes de intentar restaurar esta configuración en una computadora nueva o limpia, asegúrate de tener instalados los siguientes paquetes básicos:

```bash
sudo pacman -S git stow hyprland kitty rofi fastfetch neofetch btop
```
*(Nota: Quickshell, Cava, Wallust y linux-wallpaperengine deben ser instalados por separado o a través de AUR/paru/yay según corresponda).*

## 🚀 Cómo Restaurar Todo (Guía de Supervivencia)

Si se te rompió algo, borraste una carpeta sin querer, o acabas de instalar Arch Linux desde cero, sigue estos 3 pasos:

### 1. Clonar el Repositorio
Primero, bájate esta bóveda a tu carpeta de inicio (`~`):
```bash
cd ~
git clone git@github.com:MiaFate/dotfiles.git
cd dotfiles
```

### 2. Limpiar (Si es necesario)
Si ya tienes una carpeta `~/.config/hypr` o `~/.config/quickshell` que viene por defecto, **bórrala o cámbiale el nombre**. Stow no va a crear enlaces si ya existe un archivo o carpeta real en ese lugar.
```bash
rm -rf ~/.config/hypr ~/.config/quickshell ~/.config/kitty # (etc...)
```

### 3. Ejecutar Stow (La Magia)
Desde adentro de la carpeta `~/dotfiles`, simplemente ejecuta:
```bash
stow desktop-quickshell
```

¡Listo! Stow acaba de crear hologramas (enlaces simbólicos) de todas las configuraciones directo a tu `~/.config/`. 

### 4. Recargar el Entorno
- Si Hyprland está corriendo, recárgalo (usualmente con `Super + M` o cerrando sesión).
- Si Quickshell estaba abierto, reinícialo con `killall quickshell && quickshell &`.

## 🖼️ Sobre los Wallpapers
Los fondos de Wallpaper Engine ya vienen incluidos en la carpeta `wallpapers/` de este repositorio. El archivo `Startup_Apps.conf` de Hyprland ya está configurado para apuntar a esa carpeta, ¡así que no necesitas volver a descargarlos ni configurar Steam!
