import QtQuick
import QtQuick.Window
import "pages" // Import the folder to access CounterPage

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Professional Counter App")

    CounterPage {
        anchors.fill: parent
    }
}