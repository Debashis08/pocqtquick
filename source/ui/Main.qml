import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material

ApplicationWindow {
    id: root
    width: 600
    height: 500 // Increased height slightly to fit the new info
    visible: true
    title: "QML Counter & Secrets"

    // Force the Light theme
    Material.theme: Material.Light

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        // --- Original Counter Section ---
        Label {
            id: countLabel
            text: counter.count
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 48
            font.bold: true
            color: "black"
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15

            Button {
                text: "Increment"
                onClicked: counter.increment()
            }

            Button {
                text: "Reset"
                onClicked: counter.reset()
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

        // Displaying the Client ID fetched from C++
        Label {
            text: "Client ID: " + (counter.clientId ? counter.clientId : "Not Found")
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 12
            color: "#555"
        }

        // Button to verify the Secret (Logged to console only for safety)
        Button {
            text: "Log Secret to Console"
            Layout.alignment: Qt.AlignHCenter
            Material.background: Material.Grey
            onClicked: {
                console.log("--------------------------------")
                console.log("Fetching secrets from C++ backend:")
                console.log("Client ID:     " + counter.clientId)
                console.log("Client Secret: " + counter.clientSecret)
                console.log("--------------------------------")
            }
        }
    }
}