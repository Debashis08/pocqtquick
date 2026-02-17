#include <QtTest>
#include "core/ServiceInitializer.h"
#include "core/ServiceProvider.h"

class TestServiceInitializer : public QObject
{
    Q_OBJECT

private slots:
    void test_bootstrapping()
    {
        // Ensure Registry is initially empty (or reset it)
        ServiceProvider::instance().setCounterService(nullptr);
        QVERIFY(ServiceProvider::instance().counter() == nullptr);

        // Run the Initializer
        ServiceInitializer init;
        init.initialize();

        // Verify the Registry is now populated
        QVERIFY(ServiceProvider::instance().counter() != nullptr);
        
        // Verify it is the correct type
        QCOMPARE(ServiceProvider::instance().counter()->count(), 0);
    }
};

QTEST_MAIN(TestServiceInitializer)
#include "tst_ServiceInitializer.moc"
