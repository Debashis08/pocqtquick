import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import App.Ui 1.0
import App.Backend 1.0

Item {
    id: root
    width: 400; height: 300 // Give it size for testing

    CounterViewModel {
        id: internalViewModel
        service: ServiceProvider.counter
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            // --- ADD THIS ---
            objectName: "countLabel"
            // ----------------
            text: "Count: " + internalViewModel.count
            font.pixelSize: 32
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            StandardButton {
                // --- ADD THIS ---
                objectName: "decrementButton"
                // ----------------
                text: "-"
                backgroundColor: "#dc3545"
                onClicked: internalViewModel.decrement()
            }

            StandardButton {
                // --- ADD THIS ---
                objectName: "incrementButton"
                // ----------------
                text: "+"
                backgroundColor: "#28a745"
                onClicked: internalViewModel.increment()
            }
        }

        // ... (rest of file remains same)
    }
}
