import QtQuick
import QtQuick.Window
// Import the folder to access CounterPage
import "pages"

Window
{
    width: 640
    height: 480
    visible: true
    title: qsTr("Professional Counter App")

    CounterPage {
        anchors.fill: parent
    }
}
