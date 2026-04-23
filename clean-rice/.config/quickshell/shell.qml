//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import "./modules/common/"
import "./modules/overview/"
import "./modules/bar/"
import "./modules/visualizer/"
import "./modules/wallpaper/"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "./services/"
import "./modules/common/widgets/"


ShellRoot {
    // Enable/disable modules here. False = not loaded at all, so rest assured
    // no unnecessary stuff will take up memory if you decide to only use, say, the overview.
    property bool enableOverview: true
    property bool enableWallpaper: false // Disabled to use Wallpaper Engine

    // Force initialization of some singletons
    Component.onCompleted: {
        MaterialThemeLoader.reapplyTheme()
        ConfigLoader.loadConfig()
    }

    Loader { active: enableOverview; sourceComponent: Overview {} }
    Loader { sourceComponent: Bar {} }
    Loader { active: enableWallpaper; sourceComponent: Wallpaper {} }
    Visualizer {}
    DesktopClock {}
}