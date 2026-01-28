#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include "backend/services/LoggerService.h"

int main(int argc, char *argv[])
{

    // 1. Initialize Logger FIRST
    LoggerService::init();
    
    qInfo() << "Application Starting"; // This will now go to your file!

    QQuickStyle::setStyle("Basic");
    
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // --- FIX IS HERE ---
    // Manually add the resource root to the import path.
    // This allows "App.Ui" to find its sibling "App.Backend".
    engine.addImportPath(":/qt/qml");
    // -------------------

    engine.loadFromModule("App.Ui", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
