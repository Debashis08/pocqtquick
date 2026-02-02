import QtQuick
import QtQuick.Controls

Button {
    id: control
    property color backgroundColor: "#007bff"
    property color textColor: "#ffffff"

    background: Rectangle {
        color: control.down ? Qt.darker(control.backgroundColor, 1.1) : control.backgroundColor
        radius: 8
    }

    contentItem: Text {
        text: control.text
        color: control.textColor
        font.pixelSize: 16
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}