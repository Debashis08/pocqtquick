#include <QtQuickTest>
#include <QQmlEngine>
#include "core/ServiceProvider.h"
#include "interfaces/ICounterService.h"

// 1. Define the Mock Service
class MockCounterService : public ICounterService {
    Q_OBJECT
public:
    int m_count = 0;

    void increment() override {
        m_count++;
        emit countChanged(m_count);
    }

    void decrement() override {
        m_count--;
        emit countChanged(m_count);
    }

    int count() const override { return m_count; }

    std::string getClientId() const override { return "mock_client_id"; }
    std::string getClientSecret() const override { return "mock_client_secret"; }
};

// 2. Define the Setup Class
class Setup : public QObject {
    Q_OBJECT
public:
    Setup() {}

public slots:
    // This function is called automatically by Qt Test before QML loads
    void qmlEngineAvailable(QQmlEngine *engine) {
        Q_UNUSED(engine)

        // --- INJECT THE MOCK HERE ---
        static MockCounterService mock;
        ServiceProvider::instance().setCounterService(&mock);
    }
};

// 3. Register the Setup with the Test Runner
QUICK_TEST_MAIN_WITH_SETUP(tst_CounterPage, Setup)

#include "TestSetup.moc"
