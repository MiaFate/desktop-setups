# Apps de Hyprland Pendientes para el Rice

Aquí listamos las aplicaciones del ecosistema Hypr que podemos integrar para llevar este "Clean Start" al siguiente nivel.

## 🔐 Seguridad y Bloqueo
- [x] **Hyprlock**: Configurar pantalla de bloqueo estética con desenfoque y reloj.
- [x] **Hypridle**: Configurar auto-bloqueo y suspensión tras X minutos de inactividad.

## 🎨 Estética y Efectos
- [x] **hyprshade**: Filtros de pantalla (Luz nocturna 3400K, Grayscale, Vibrance). [Completado]
    - *Integración*: Botones añadidos al Control Center de Quickshell.
- [x] **hyprcursor**: Mejora de cursores en Wayland con Bibata-Modern-Ice. [Completado]

## 🛠️ Utilidades
- [x] **hyprpicker**: Selector de colores integrado en el Control Center. [Completado]
- [x] **hyprshot**: Capturas de pantalla integradas en el Control Center. [Completado]
- [x] **hyprpolkitagent**: Agente de autenticación visual. [Completado]
    - *Acción*: Habilitado y en ejecución (`systemctl --user enable --now hyprpolkitagent`).
- [ ] **Inhibidor de Sueño (Modo Facultad/Remoto)**:
    - *Atajo*: `Super + Alt + I` (Ejecuta `Hypridle.sh toggle`).
    - *Quickshell*: Agregar botón al Control Center para activar/desactivar visualmente el bloqueo y la suspensión.

## 📊 Barra y Sistema
- [ ] **Quickshell (Avanzado)**: Seguir personalizando la barra actual.
    - *Tareas*: Dashboard, control de volumen visual, selector de perfiles de energía.
- [x] **Optimización de Visualizador**:
    - *Estado*: ✅ **Completado**. CPU usage reducido a ~6.6% usando native shapes y shaders en Quickshell.

## 🚀 Optimizaciones de Aplicaciones y Widgets
- [ ] **Alternativas a Apps Pesadas**:
    - *Discord*: Buscar clientes más ligeros (Vesktop con optimizaciones, Discord-Screen-Share o web wrapper).
    - *Spotify*: Migrado a `spotify-launcher` con soporte Wayland Nativo (truco `env -u DISPLAY`). [Completado]
- [ ] **Migración de Widgets (Eww -> Quickshell)**:
    - [x] **Reloj de Escritorio**: Reemplazar el widget de reloj de Eww por una versión nativa en Quickshell para eliminar la dependencia de Eww. [Completado]
    - *Fuentes*: Buscar una fuente más estética/stylized para el nuevo Desktop Clock.
- [x] **Optimización de Fondo de Pantalla**:
    - *awww*: Migrado de Wallpaper Engine a `awww` para reducir uso de VRAM (~1.3GB ahorrados) y CPU. [Completado]

## ⚡ Optimización de Arranque Extrema
- [x] **Eliminar Snaps**: Purgar `snapd` para quitar los mounts que retrasaban el inicio. [Completado]
- [x] **GRUB Instantáneo**: Configurado `TIMEOUT=0` y `hidden`. [Completado]
- [ ] **BIOS Fast Boot**: Activar en la placa MSI para reducir los 15s de Firmware.
