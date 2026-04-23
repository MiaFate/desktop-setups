# Apps de Hyprland Pendientes para el Rice

Aquí listamos las aplicaciones del ecosistema Hypr que podemos integrar para llevar este "Clean Start" al siguiente nivel.

## 🔒 Seguridad e Inactividad
- [ ] **hyprlock**: Bloqueador de pantalla nativo.
    - *Cómo agregar*: Crear `hyprlock.conf` y configurar imágenes/relojes.
- [ ] **hypridle**: Gestión de inactividad.
    - *Cómo agregar*: Configurar tiempos de espera para bloquear pantalla y apagar monitores.

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
