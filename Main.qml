import QtQuick

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("poc qt quick")

    Column {
            anchors.centerIn: parent

            Text {
                text: "This is default size"
            }

            Text {
                text: "This is larger text"
                font.pixelSize: 30      // Set size in pixels
            }

            Text {
                text: "This is smaller text"
                font.pixelSize: 10
            }

            Text {
                text: "Using point size"
                font.pointSize: 20      // Size in points (device independent)
            }
        }
}
