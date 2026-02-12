#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "core/ServiceInitializer.h" // <-- UPDATED

int main(int argc, char *argv[])
{
    qputenv("QT_QUICK_CONTROLS_CONF", ":/pocqtquick-qtquickcontrols2.conf");
    QGuiApplication app(argc, argv);

    // --- UPDATED ---
    ServiceInitializer initializer;
    initializer.initialize();
    // ---------------

    QQmlApplicationEngine engine;
    engine.addImportPath(":/qt/qml");
    engine.loadFromModule("App.Ui", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}