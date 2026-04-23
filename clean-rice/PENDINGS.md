# Apps de Hyprland Pendientes para el Rice

Aquí listamos las aplicaciones del ecosistema Hypr que podemos integrar para llevar este "Clean Start" al siguiente nivel.

## 🔐 Seguridad y Bloqueo
- [x] **Hyprlock**: Configurar pantalla de bloqueo estética con desenfoque y reloj.
- [x] **Hypridle**: Configurar auto-bloqueo y suspensión tras X minutos de inactividad.

## 🎨 Estética y Efectos
- [ ] **hyprshade**: Filtros de pantalla (Luz nocturna, Grayscale, Vibrance).
    - *Cómo agregar*: Instalar y añadir binds para activar/desactivar filtros.
- [ ] **hyprcursor**: Mejora de cursores en Wayland.
    - *Estado*: Ya configurado en `envs.conf`.

## 🛠️ Utilidades
- [ ] **hyprpicker**: Selector de colores.
    - *Estado*: Configurado con bind `SUPER + P`.
    - *Mejora*: Integrar botón en la barra de Quickshell.
- [ ] **hyprshot**: Screenshots más nativos.
    - *Cómo agregar*: Reemplazar o complementar el script de Jakoolit.
- [ ] **hyprpolkitagent**: Agente de autenticación visual.
    - *Cómo agregar*: Añadir al `autostart.conf`.

## 📊 Barra y Sistema
- [ ] **Quickshell (Avanzado)**: Seguir personalizando la barra actual.
    - *Tareas*: Dashboard, control de volumen visual, selector de perfiles de energía.
- [ ] **Optimización de Visualizador**:
    - *Problema*: Consumo de CPU muy alto (~20%).
    - *Solución*: Rediseñar el sistema de dibujo (Canvas) para evitar crear objetos en cada frame o buscar alternativas más ligeras que Cava + QML.

## 🚀 Optimizaciones de Aplicaciones y Widgets
- [ ] **Alternativas a Apps Pesadas**:
    - *Discord*: Buscar clientes más ligeros (Vesktop con optimizaciones, Discord-Screen-Share o web wrapper).
    - *Spotify*: Migrado a `spotify-launcher` con soporte Wayland Nativo (truco `env -u DISPLAY`). [Completado]
- [ ] **Migración de Widgets (Eww -> Quickshell)**:
    - [x] **Reloj de Escritorio**: Reemplazar el widget de reloj de Eww por una versión nativa en Quickshell para eliminar la dependencia de Eww. [Completado]
    - *Fuentes*: Buscar una fuente más estética/stylized para el nuevo Desktop Clock.
- [x] **Optimización de Fondo de Pantalla**:
    - *awww*: Migrado de Wallpaper Engine a `awww` para reducir uso de VRAM (~1.3GB ahorrados) y CPU. [Completado]
