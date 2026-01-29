import QtQuick
import QtQuick.Layouts
import QtQuick.Controls // Required for Button and Label
import App.Ui 1.0
import App.Backend 1.0

Item {
    id: root

    // 'bridge' is now a public name for the private object 'internalBridge'
    property alias bridge: internalBridge

    // Instantiate the C++ Class
    CounterBridge {
        id: internalBridge
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            // Using the alias 'bridge' to access the 'count' property
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

        // --- NEW: Secrets Demonstration Section ---

        // A visual divider
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

        // FIX 1: Changed 'counter.clientId' to 'bridge.clientId'
        Label {
            text: "Client ID: " + (bridge.clientId ? bridge.clientId : "Not Found")
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 12
            color: "#555"
        }

        // Button to verify the Secret
        Button {
            text: "Log Secret to Console"
            Layout.alignment: Qt.AlignHCenter
            // Material.background only works if you are using Material style,
            // otherwise use 'palette.button' or custom background

            onClicked: {
                console.log("--------------------------------")
                console.log("Fetching secrets from C++ backend:")
                // FIX 2: Changed 'counter' to 'bridge' here as well
                console.log("Client ID:      " + bridge.clientId)
                console.log("Client Secret: " + bridge.clientSecret)
                console.log("--------------------------------")
            }
        }
    }
}
