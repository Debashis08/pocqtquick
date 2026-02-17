#include <QtTest>
#include "viewmodels/CounterViewModel.h"
#include "interfaces/ICounterService.h"

// mock service
// A fake implementation that tracks calls
class MockCounterService : public ICounterService
{
    Q_OBJECT
public:
    int mockCount = 0;
    bool incrementCalled = false;
    bool decrementCalled = false;

    void increment() override
    {
        incrementCalled = true;
        mockCount++;
        emit countChanged(mockCount);
    }

    void decrement() override
    {
        decrementCalled = true;
        mockCount--;
        emit countChanged(mockCount);
    }

    int count() const override
    {
        return mockCount;
    }

    std::string getClientId() const override
    {
        return "test_id";
    }

    std::string getClientSecret() const override
    {
        return "test_secret";
    }
};

// The test class
class TestCounterViewModel : public QObject
{
    Q_OBJECT

private slots:
    void test_injection_updates_ui()
    {
        CounterViewModel vm;
        MockCounterService mock;
        mock.mockCount = 10;

        // INJECT MOCK
        vm.setService(&mock);

        // Verify UI Properties updated
        QCOMPARE(vm.count(), 10);
        QCOMPARE(vm.clientId(), "test_id");
    }

    void test_user_interaction()
    {
        CounterViewModel vm;
        MockCounterService mock;
        vm.setService(&mock);

        // Simulate User Clicking "+"
        vm.increment();

        // Verify the mock was called
        QVERIFY(mock.incrementCalled);
        QCOMPARE(vm.count(), 1);
    }

    void test_handles_null_service()
    {
        CounterViewModel vm;
        vm.setService(nullptr);

        // Should not crash
        vm.increment();
        QCOMPARE(vm.count(), 0);
        QCOMPARE(vm.clientId(), "No Service");
    }
};

QTEST_MAIN(TestCounterViewModel)
#include "tst_CounterViewModel.moc"
