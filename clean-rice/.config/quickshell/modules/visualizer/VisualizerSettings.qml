pragma Singleton
import QtQuick

QtObject {
    property bool enabled: true
    property string style: "bars" // "bars", "waves" or "cyber"
    property int barCount: 64
}
