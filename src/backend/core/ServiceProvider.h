#pragma once
#include <QObject>
#include <QQmlEngine>
#include "interfaces/ICounterService.h"

// The new name for AppRegistry
class ServiceProvider : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON // QML will now know this as "ServiceProvider"

    Q_PROPERTY(ICounterService* counter READ counter CONSTANT)

public:
    static ServiceProvider& instance();
    static ServiceProvider* create(QQmlEngine *qmlEngine, QJSEngine *jsEngine);

    void setCounterService(ICounterService* service);
    ICounterService* counter() const;

private:
    explicit ServiceProvider(QObject* parent = nullptr) : QObject(parent) {}
    ICounterService* m_counterService = nullptr;
};