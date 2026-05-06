# 🔡 Configuración de Fuentes del Sistema

Este documento registra las fuentes utilizadas en el entorno actual para asegurar la consistencia visual entre aplicaciones GTK, Qt y herramientas de UI.

## 1. Fuente Principal: **SF Pro Display**
Es la fuente tipográfica de Apple, utilizada para la interfaz general, menús y barras laterales.

### Ubicaciones de Configuración (Verificadas)

| Entorno | Archivo de Configuración | Valor |
| :--- | :--- | :--- |
| **GTK 3** | `~/.config/gtk-3.0/settings.ini` | `SF Pro Display 12` |
| **GTK 4** | `~/.config/gtk-4.0/settings.ini` | `SF Pro Display 12` |
| **GTK 2** | `~/.gtkrc-2.0` | `SF Pro Display 12` |
| **Qt 5** | `~/.config/qt5ct/qt5ct.conf` | `SF Pro Display 14` (General) |
| **Qt 6** | `~/.config/qt6ct/qt6ct.conf` | `SF Pro Display 14` (General) |

## 2. Fuentes Adicionales
- **Monoespaciada**: JetBrains Mono Nerd Font (configurada en terminales y editores).
- **Caracteres CJK**: Noto Fonts CJK (para soporte de japonés/chino/coreano).

## 3. Notas de Renderizado
- **Antialiasing**: Habilitado.
- **Hinting**: `hintslight`.
- **RGBA**: `rgb`.

---
*Última actualización: 6 de mayo de 2026*
