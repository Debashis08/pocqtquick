import QtQuick
import QtTest
import QtQuick.Controls
import App.Ui 1.0

TestCase {
    name: "CounterPageTests"
    when: windowShown
    width: 600
    height: 600

    CounterPage {
        id: page
        anchors.fill: parent
    }

    // --- RECURSIVE FIND HELPER ---
    // Standard function to find items in a deep hierarchy
    function findChild(parentItem, objectName) {
        if (!parentItem) return null;

        // 1. Check direct children
        var children = parentItem.children;
        for (var i = 0; i < children.length; i++) {
            var child = children[i];
            if (child.objectName === objectName) return child;

            // 2. Recurse deep
            var result = findChild(child, objectName);
            if (result) return result;
        }
        return null;
    }

    // --- TEST CASES ---

    function test_defaults() {
        var label = findChild(page, "countLabel");

        // Use 'verify' to stop test if null (avoids crash)
        verify(label !== null, "Could not find countLabel");
        compare(label.text, "Count: 0", "Initial mock count should be 0");
    }

    function test_increment() {
        var btn = findChild(page, "incrementButton");
        var label = findChild(page, "countLabel");

        verify(btn !== null, "Could not find incrementButton");
        verify(label !== null, "Could not find countLabel");

        // Simulate Click
        mouseClick(btn);

        // Verify Update
        compare(label.text, "Count: 1", "Count should increase to 1");
    }

    function test_decrement() {
        var btn = findChild(page, "decrementButton");
        var label = findChild(page, "countLabel");

        verify(btn !== null, "Could not find decrementButton");

        // Logic: 1 (from previous test) - 1 = 0
        mouseClick(btn);

        compare(label.text, "Count: 0", "Count should decrease to 0");
    }
}
