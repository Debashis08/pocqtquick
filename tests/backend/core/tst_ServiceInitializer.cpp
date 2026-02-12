#include <QtTest>
#include "core/ServiceInitializer.h"
#include "core/ServiceProvider.h"

class TestServiceInitializer : public QObject {
    Q_OBJECT

private slots:
    void test_bootstrapping() {
        // 1. Ensure Registry is initially empty (or reset it)
        ServiceProvider::instance().setCounterService(nullptr);
        QVERIFY(ServiceProvider::instance().counter() == nullptr);

        // 2. Run the Initializer
        ServiceInitializer init;
        init.initialize();

        // 3. Verify the Registry is now populated
        QVERIFY(ServiceProvider::instance().counter() != nullptr);
        
        // Optional: verify it is the correct type
        QCOMPARE(ServiceProvider::instance().counter()->count(), 0);
    }
};

QTEST_MAIN(TestServiceInitializer)
#include "tst_ServiceInitializer.moc"