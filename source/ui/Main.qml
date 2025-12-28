import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material // 1. Import the Material module

// ApplicationWindow provides the main window for the application.
ApplicationWindow {
    id: root
    width: 600
    height: 400
    visible: true
    title: "QML Counter"

    // 2. Force the Light theme
    Material.theme: Material.Light

    // Center the main content column within the window.
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        // This label displays the counter's value.
        Label {
            id: countLabel
            text: counter.count
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 48
            font.bold: true

            // Ensure text is dark since we are forcing a light background
            // (Material.Light usually handles this, but this is a safe fallback)
            color: "black"
        }

        // A row layout for the buttons.
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15

            Button {
                text: "Increment"
                onClicked: {
                    counter.increment()
                }
            }

            Button {
                text: "Reset"
                onClicked: {
                    counter.reset()
                }
            }
        }
    }
}
