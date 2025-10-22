#include <QtTest/QtTest>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QQuickItem>
#include "backend/counter.h"

class MainQmlTest : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase()
    {
        qDebug() << "Loading QML UI for test...";
    }

    void test_qml_loads_successfully()
    {
        using namespace Qt::StringLiterals;

        QQmlApplicationEngine engine;

        // --- Register backend object for QML ---
        Counter counter;
        engine.rootContext()->setContextProperty("counter", &counter);

        // --- Optional: print QML warnings for debugging ---
        QObject::connect(&engine, &QQmlApplicationEngine::warnings,
                         [](const QList<QQmlError> &warnings) {
                             for (const auto &err : warnings)
                                 qWarning() << "QML Warning:" << err.toString();
                         });

        // --- Load Main.qml from resource system ---
        const QUrl url(u"qrc:/ui/Main.qml"_s);
        engine.load(url);

        // --- Validate load success ---
        QVERIFY2(!engine.rootObjects().isEmpty(), "Main.qml failed to load.");

        QObject *rootObject = engine.rootObjects().first();
        QVERIFY(rootObject != nullptr);
        QVERIFY(rootObject->isWindowType());

        QQuickWindow *window = qobject_cast<QQuickWindow *>(rootObject);
        QVERIFY(window);

        qDebug() << "Main.qml loaded successfully with Counter registered.";
    }

    void cleanupTestCase()
    {
        qDebug() << "Finished UI QML tests.";
    }
};

QTEST_MAIN(MainQmlTest)
#include "MainQmlTest.moc"
