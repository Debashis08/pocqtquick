#include <QtTest>
#include "core/ServiceProvider.h"
// Needed for a real object to test with
#include "services/CounterService.h"

class TestServiceProvider : public QObject
{
    Q_OBJECT

private slots:
    void test_singleton_behavior()
    {
        // Verify multiple calls return the same memory address
        auto* instance1 = &ServiceProvider::instance();
        auto* instance2 = &ServiceProvider::instance();
        
        QCOMPARE(instance1, instance2);
    }

    void test_service_holding()
    {
        ServiceProvider& provider = ServiceProvider::instance();
        CounterService service;

        // Set the service
        provider.setCounterService(&service);

        // Get it back
        QCOMPARE(provider.counter(), &service);
    }
};

QTEST_MAIN(TestServiceProvider)
#include "tst_ServiceProvider.moc"
