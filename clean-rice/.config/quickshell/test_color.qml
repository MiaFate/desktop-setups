import QtQuick

Rectangle {
    width: 100; height: 100
    color: "#1e1e2eff"
    Component.onCompleted: {
        console.log("R:", color.r, "G:", color.g, "B:", color.b, "A:", color.a)
        Qt.quit()
    }
}
