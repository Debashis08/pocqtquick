#include <QtTest>
#include <QSignalSpy>
#include "viewmodels/CounterViewModel.h"

class TestCounterViewModel : public QObject {
    Q_OBJECT

private slots:
    void testSignals() {
        CounterViewModel bridge;
        
        // Create a spy to watch the 'countChanged' signal
        QSignalSpy spy(&bridge, &CounterViewModel::countChanged);
        QVERIFY(spy.isValid());

        // Trigger the action
        bridge.increment();

        // Check if signal was emitted successfully.
        QCOMPARE(spy.count(), 1);
        QCOMPARE(bridge.count(), 1);
    }
};

QTEST_MAIN(TestCounterViewModel)
#include "tst_CounterViewModel.moc"