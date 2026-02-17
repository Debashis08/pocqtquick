import QtQuick
import QtTest
import QtQuick.Controls
import App.Ui 1.0

TestCase
{
    name: "CounterPageTests"
    // This waits for the window to actually appear before running tests
    when: windowShown

    // Make the Test Container Visible
    width: 800; height: 600
    visible: true

    CounterPage
    {
        id: page
        anchors.fill: parent
        // Ensure the page itself requests visibility
        visible: true
    }

    SignalSpy
    {
        id: clickSpy
        signalName: "clicked"
    }

    // helper method
    function findChild(parentItem, objectName)
    {
        if (!parentItem) return null;
        for (var i = 0; i < parentItem.children.length; i++)
        {
            var child = parentItem.children[i];
            if (child.objectName === objectName) return child;
            var result = findChild(child, objectName);
            if (result) return result;
        }
        return null;
    }

    function interactWithButton(btn)
    {
        // 1. Wait for layout polish (Ensure it's not 0x0 size)
        wait(200);

        // 2. Verify Visibility
        verify(btn.visible, "Button is invisible - check parent visibility");
        verify(btn.enabled, "Button is disabled");

        // 3. Force Focus & Press Space
        // This is safer than mouseClick for CI environments
        btn.forceActiveFocus();
        verify(btn.activeFocus, "Button could not grab focus");
        keyClick(Qt.Key_Space);
    }

    // Tests
    function test_increment()
    {
        var btn = findChild(page, "incrementButton");
        var label = findChild(page, "countLabel");

        verify(btn !== null, "FATAL: Button not found");

        clickSpy.target = btn;
        clickSpy.clear();

        if (typeof MockHelper !== "undefined") MockHelper.reset();

        // Wait for the scene to be fully rendered
        waitForRendering(page);

        interactWithButton(btn);

        compare(clickSpy.count, 1, "Button click signal failed");
        tryCompare(label, "text", "Count: 1", 5000);
    }

    function test_decrement()
    {
        var btn = findChild(page, "decrementButton");
        var label = findChild(page, "countLabel");

        clickSpy.target = btn;
        clickSpy.clear();

        if (typeof MockHelper !== "undefined") MockHelper.reset();
        waitForRendering(page);

        interactWithButton(btn);

        // 0 - 1 = -1
        tryCompare(label, "text", "Count: -1", 5000);
    }
}
