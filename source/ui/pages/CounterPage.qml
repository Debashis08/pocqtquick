import QtQuick
import QtQuick.Layouts
import App.Ui 1.0
import App.Backend 1.0

Item {
    // Instantiate the C++ Class
    CounterBridge {
        id: bridge
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "Count: " + bridge.count
            font.pixelSize: 32
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            spacing: 20
            StandardButton {
                text: "-"
                backgroundColor: "#dc3545"
                onClicked: bridge.decrement()
            }

            StandardButton {
                text: "+"
                backgroundColor: "#28a745"
                onClicked: bridge.increment()
            }
        }
    }
}