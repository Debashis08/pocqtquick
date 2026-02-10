#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "core/LoggerService.h"
#include "services/CounterService.h" // Include Concrete Service

int main(int argc, char *argv[])
{
    qputenv("QT_QUICK_CONTROLS_CONF", ":/pocqtquick-qtquickcontrols2.conf");
    QGuiApplication app(argc, argv);

    LoggerService::init();
    qInfo() << "Application Starting";

    // 1. Create the Service (Lives for the whole app)
    CounterService appCounterService;

    QQmlApplicationEngine engine;

    // 2. Inject into QML Context
    engine.rootContext()->setContextProperty("appService", &appCounterService);

    engine.addImportPath(":/qt/qml");
    engine.loadFromModule("App.Ui", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}