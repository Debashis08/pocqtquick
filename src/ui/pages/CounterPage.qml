import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import App.Ui 1.0
import App.Backend 1.0

Item
{
    id: root

    CounterViewModel
    {
        id: internalViewModel
        service: ServiceProvider.counter
    }

    ColumnLayout
    {
        anchors.centerIn: parent
        spacing: 20

        Text
        {
            objectName: "countLabel"
            text: "Count: " + internalViewModel.count
            font.pixelSize: 32
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout
        {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            StandardButton
            {
                objectName: "decrementButton"
                text: "-"
                backgroundColor: "#dc3545"
                onClicked: internalViewModel.decrement()

                // --- FIX: Give it a size so the test can hit it ---
                Layout.preferredWidth: 60
                Layout.preferredHeight: 40
            }

            StandardButton
            {
                objectName: "incrementButton"
                text: "+"
                backgroundColor: "#28a745"
                onClicked: internalViewModel.increment()

                // --- FIX: Give it a size so the test can hit it ---
                Layout.preferredWidth: 60
                Layout.preferredHeight: 40
            }
        }

        // --- Secrets Demonstration Section ---
        Rectangle
        {
            Layout.fillWidth: true
            Layout.preferredWidth: 200
            Layout.alignment: Qt.AlignHCenter
            height: 1
            color: "#e0e0e0"
            Layout.topMargin: 20
        }

        Label
        {
            text: "OAuth Configuration (From CMake)"
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
            color: "grey"
        }

        Label
        {
            text: "Client ID: " + (internalViewModel.clientId ? internalViewModel.clientId : "Not Found")
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 12
            color: "#555"
        }

        Button
        {
            text: "Log Secret to Console"
            Layout.alignment: Qt.AlignHCenter
            onClicked:
            {
                console.log("--------------------------------")
                console.log("Fetching secrets from C++ backend:")
                console.log("Client ID:      " + internalViewModel.clientId)
                console.log("Client Secret: " + internalViewModel.clientSecret)
                console.log("--------------------------------")
            }
        }
    }
}
