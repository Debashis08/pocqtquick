import QtQuick
import QtTest
import App.Ui 1.0       // Your UI Module
import App.Backend 1.0  // Your Backend Module

TestCase {
    name: "CounterPageTests"
    width: 400
    height: 400
    visible: true
    when: windowShown

    // Instantiate the page you want to test
    CounterPage {
        id: page
        anchors.fill: parent
    }

    // IMPORTANT: For this to work, ensure your CounterPage.qml 
    // exposes the bridge using an alias: 
    // property alias bridge: internalBridgeId

    function test_increment_logic() {
        // Verify initial state
        verify(page.bridge !== null, "Bridge should exist")
        var start = page.bridge.count
        
        // Trigger action
        page.bridge.increment()
        
        // Verify result
        compare(page.bridge.count, start + 1, "Count should increase")
    }
    
    function test_decrement_logic() {
        var start = page.bridge.count
        page.bridge.decrement()
        compare(page.bridge.count, start - 1, "Count should decrease")
    }
}