import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import App.Ui 1.0
import App.Backend 1.0

Item {
    id: root

    property alias bridge: internalViewModel

    CounterViewModel {
        id: internalViewModel
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
            // --- FIX: This aligns the entire row of buttons to the center ---
            Layout.alignment: Qt.AlignHCenter

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

        // --- Secrets Demonstration Section ---
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignHCenter
            height: 1
            color: "#e0e0e0"
            Layout.topMargin: 20
        }

        Label {
            text: "OAuth Configuration (From CMake)"
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            color: "grey"
        }

        Label {
            text: "Client ID: " + (bridge.clientId ? bridge.clientId : "Not Found")
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 12
            color: "#555"
        }

        Button {
            text: "Log Secret to Console"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                console.log("--------------------------------")
                console.log("Fetching secrets from C++ backend:")
                console.log("Client ID:      " + bridge.clientId)
                console.log("Client Secret: " + bridge.clientSecret)
                console.log("--------------------------------")
            }
        }
    }
}
