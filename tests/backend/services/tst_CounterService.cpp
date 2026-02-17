#include <QtTest>
#include "services/CounterService.h"

class TestCounterService : public QObject
{
    Q_OBJECT

private slots:
    void test_initial_value()
    {
        CounterService service;
        QCOMPARE(service.count(), 0);
    }

    void test_increment()
    {
        CounterService service;

        // Spy on the signal to ensure it fires
        QSignalSpy spy(&service, &CounterService::countChanged);

        service.increment();

        QCOMPARE(service.count(), 1);
        QCOMPARE(spy.count(), 1); // Signal fired once
        QCOMPARE(spy.takeFirst().at(0).toInt(), 1); // Argument was '1'
    }

    void test_decrement()
    {
        CounterService service;
        service.increment(); // 1
        service.decrement(); // 0

        QCOMPARE(service.count(), 0);
    }
};

QTEST_MAIN(TestCounterService)
#include "tst_CounterService.moc"
