pragma Singleton
import QtQuick

QtObject {
    // 🎨 Base
    property color primary:        "#a855f7"
    property color primarySoft:    "#c084fc"
    property color primaryDim:     "#7c3aed"

    // 🌑 Fondo
    property color bgMain:         "#1e1e2ecc"
   // property color bgPopup:        "#1e1e2e" // Popup background (100% solid)
    property color bgPopup:        '#f41e1e2e' // Popup background (100% solid)
    property color bgAlt:          "#181825cc"
    property color bgHover:        "#2a2a3a88"

    // 🔲 Bordes
    property color borderSoft:     "#94e2d5"
    property color borderStrong:   '#a89f56ed'

    // 🔤 Texto
    property color textPrimary:    '#d8acff'
    property color textSecondary:  "#cdd6f4"
    property color textMuted:      "#6c7086"

    // ⚡ Estados
    property color active:         '#696d4ab4' 
    // property color active:         '#00ffffff' 
    property color inactive:       '#72291543'
    //    property color inactive:       '#685de3'
    property color highlight:      "#f5c2e7"

    // 🖥️ System Widgets (Compatibilidad con nuevos widgets)
    property color colCpu:         primarySoft
    property color colMem:         primarySoft
    property color colDisk:        primarySoft
    property color colVol:         primarySoft
    property color colBattery:     primarySoft
    property color colNetwork:     primarySoft
    property color colBluetooth:   primarySoft
    property color colSlack:       primarySoft
    property color colWhatsapp:    primarySoft
    property color colWorkspaceActive: active
    property color colWorkspaceInactive: inactive
    property color colWindow:      textPrimary
    property color colKernel:      primaryDim
    
    // Font
    property string fontFamily:    "Font Awesome 6 Free"
    property int fontSize:         14
    
    // Fallbacks from original Theme
    property color colFg:          textPrimary
    property color colMuted:       textMuted
    property color colBg:          bgPopup
}