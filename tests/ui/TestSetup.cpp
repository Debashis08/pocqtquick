#include <QtQuickTest>
#include <QQmlEngine>
#include <QQmlContext>
#include <QDebug>
// #include <cstdlib> // For qputenv

// Includes for your backend logic
#include "core/ServiceProvider.h"
#include "interfaces/ICounterService.h"

// -----------------------------------------------------------------------------
// 0. FORCE "BASIC" STYLE (CRITICAL FIX)
// -----------------------------------------------------------------------------
// This struct ensures we set the style to "Basic" before the QGuiApplication
// in main() is even created. This fixes the "geometry=0,0" and customization errors.
struct StyleConfig {
    StyleConfig() {
        qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");
    }
};
static StyleConfig styleConfig;

// -----------------------------------------------------------------------------
// 1. Mock Service Definition
// -----------------------------------------------------------------------------
class MockCounterService : public ICounterService {
    Q_OBJECT
public:
    explicit MockCounterService(QObject *parent = nullptr) : ICounterService(parent) {}

    int m_count = 0;

    void increment() override {
        m_count++;
        qDebug() << "Mock: Increment called. New count:" << m_count;
        emit countChanged(m_count);
    }

    void decrement() override {
        m_count--;
        qDebug() << "Mock: Decrement called. New count:" << m_count;
        emit countChanged(m_count);
    }

    int count() const override { return m_count; }
    std::string getClientId() const override { return "test_id"; }
    std::string getClientSecret() const override { return "test_secret"; }

    Q_INVOKABLE void reset() {
        m_count = 0;
        emit countChanged(m_count);
        qDebug() << "Mock: Service Reset -> Count is 0";
    }
};

// -----------------------------------------------------------------------------
// 2. Test Setup Class
// -----------------------------------------------------------------------------
class Setup : public QObject {
    Q_OBJECT
public:
    Setup() {}

public slots:
    void qmlEngineAvailable(QQmlEngine *engine) {
        // 1. Set Import Path so 'import App.Ui' works
        engine->addImportPath("qrc:/qt/qml");

        // 2. Create the Mock (Heap allocated to persist)
        MockCounterService* mock = new MockCounterService(engine);

        // 3. Inject into C++ Backend (So ViewModel finds it)
        ServiceProvider::instance().setCounterService(mock);

        // 4. Inject into QML (So Test can reset it)
        engine->rootContext()->setContextProperty("MockHelper", mock);
    }
};

// -----------------------------------------------------------------------------
// 3. Main Entry Point
// -----------------------------------------------------------------------------
QUICK_TEST_MAIN_WITH_SETUP(tst_ui, Setup)

#include "TestSetup.moc"
