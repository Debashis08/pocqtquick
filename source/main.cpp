#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "backend/counter.h"

int main(int argc, char *argv[])
{
    using namespace Qt::StringLiterals;

    // Create the main application instance.
    QGuiApplication app(argc, argv);

    // The QML engine that will load and run our QML code.
    QQmlApplicationEngine engine;

    // Create an instance of our C++ Counter backend.
    Counter myCounter;

    // Expose the C++ object to QML.
    // The root context's setContextProperty method makes 'myCounter' available
    // to all QML components loaded by the engine under the name "counter".
    engine.rootContext()->setContextProperty("counter", &myCounter);

    // Define the URL for the main QML file.
    // "qrc:" refers to the Qt Resource System, which we defined in qml.qrc.
    const QUrl url(u"qrc:/ui/Main.qml"_s);

    // If the QML object is destroyed, quit the application.
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && url == objUrl)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    // Load the main QML file.
    engine.load(url);

    // Start the application's event loop.
    return app.exec();
}

