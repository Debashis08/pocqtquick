#include <QtTest/QtTest>
#include "backend/counter.h"

class CounterTest : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase()
    {
        qDebug() << "Starting Counter tests...";
    }

    void test_initialValue()
    {
        Counter c;
        QCOMPARE(c.count(), 0);
    }

    void test_increment()
    {
        Counter c;
        c.increment();
        QCOMPARE(c.count(), 1);
    }

    void cleanupTestCase()
    {
        qDebug() << "Finished Counter tests.";
    }
};

QTEST_MAIN(CounterTest)
#include "counterTest.moc"
