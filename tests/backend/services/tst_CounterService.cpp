#include <QtTest>
#include "services/CounterService.h"

class TestCounterService : public QObject {
    Q_OBJECT

private slots:
    void testInitialValue() {
        CounterService service;
        QCOMPARE(service.value(), 0);
    }

    void testIncrement() {
        CounterService service;
        service.increment();
        QCOMPARE(service.value(), 1);
        service.increment();
        QCOMPARE(service.value(), 2);
    }

    void testDecrement() {
        CounterService service;
        service.decrement();
        QCOMPARE(service.value(), -1);
    }
};

QTEST_MAIN(TestCounterService)
#include "tst_CounterService.moc"