import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// ApplicationWindow provides the main window for the application.
ApplicationWindow {
    id: root
    width: 600
    height: 400
    visible: true
    title: "QML Counter"

    // Center the main content column within the window.
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        // This label displays the counter's value.
        // The 'text' property is bound to the 'count' property of our C++ backend.
        // When the C++ 'countChanged' signal is emitted, this text will update automatically.
        Label {
            id: countLabel
            text: counter.count // "counter" is the name we'll register in main.cpp
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 48
            font.bold: true
        }

        // A row layout for the buttons.
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15

            // The "Increment" button.
            // When clicked, it calls the 'increment()' method on our C++ object.
            Button {
                text: "Increment"
                onClicked: {
                    counter.increment()
                }
            }

            // The "Reset" button.
            // When clicked, it calls the 'reset()' method on our C++ object.
            Button {
                text: "Reset"
                onClicked: {
                    counter.reset()
                }
            }
        }
    }
}
