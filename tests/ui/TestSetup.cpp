#include <QtQuickTest>
#include <QQmlEngine>
#include <QQmlContext>
#include <QDebug>
// #include <cstdlib> // For qputenv

// Includes for your backend logic
#include "core/ServiceProvider.h"
#include "interfaces/ICounterService.h"

// Force "BASIC" style
// This struct ensures we set the style to "Basic" before the QGuiApplication
// in main() is even created. This fixes the "geometry=0,0" and customization errors.
struct StyleConfig
{
    StyleConfig()
    {
        qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");
    }
};
static StyleConfig styleConfig;

// Mock Service Definition
class MockCounterService : public ICounterService
{
    Q_OBJECT
public:
    explicit MockCounterService(QObject *parent = nullptr) : ICounterService(parent) {}

    int _count = 0;

    void increment() override
    {
        _count++;
        qDebug() << "Mock: Increment called. New count:" << _count;
        emit countChanged(_count);
    }

    void decrement() override
    {
        _count--;
        qDebug() << "Mock: Decrement called. New count:" << _count;
        emit countChanged(_count);
    }

    int count() const override { return _count; }
    std::string getClientId() const override { return "test_id"; }
    std::string getClientSecret() const override { return "test_secret"; }

    Q_INVOKABLE void reset()
    {
        _count = 0;
        emit countChanged(_count);
        qDebug() << "Mock: Service Reset -> Count is 0";
    }
};

// Test Setup Class
class Setup : public QObject
{
    Q_OBJECT
public:
    Setup() {}

public slots:
    void qmlEngineAvailable(QQmlEngine *engine)
    {
        // Set Import Path so 'import App.Ui' works
        engine->addImportPath("qrc:/qt/qml");

        // Create the Mock (Heap allocated to persist)
        MockCounterService* mock = new MockCounterService(engine);

        // Inject into C++ Backend (So ViewModel finds it)
        ServiceProvider::instance().setCounterService(mock);

        // Inject into QML (So Test can reset it)
        engine->rootContext()->setContextProperty("MockHelper", mock);
    }
};

// Main Entry Point
QUICK_TEST_MAIN_WITH_SETUP(tst_ui, Setup)
#include "TestSetup.moc"
