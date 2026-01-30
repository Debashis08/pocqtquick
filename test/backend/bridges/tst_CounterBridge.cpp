#include <QtTest>
#include <QSignalSpy>
#include "bridges/CounterBridge.h"

class TestCounterBridge : public QObject {
    Q_OBJECT

private slots:
    void testSignals() {
        CounterBridge bridge;
        
        // Create a spy to watch the 'countChanged' signal
        QSignalSpy spy(&bridge, &CounterBridge::countChanged);
        QVERIFY(spy.isValid());

        // Trigger the action
        bridge.increment();

        // Check if signal was emitted
        QCOMPARE(spy.count(), 1);
        QCOMPARE(bridge.count(), 1);
    }
};

QTEST_MAIN(TestCounterBridge)
#include "tst_CounterBridge.moc"