#pragma once
#include <QObject>
#include <QtQml/qqmlregistration.h>
#include "services/CounterService.h"

class CounterViewModel : public QObject {
    Q_OBJECT
    QML_ELEMENT
    // Existing property
    Q_PROPERTY(int count READ count NOTIFY countChanged)

    // --- ADD THESE ---
    // We use CONSTANT because these config values likely won't change during runtime
    Q_PROPERTY(QString clientId READ clientId CONSTANT)
    Q_PROPERTY(QString clientSecret READ clientSecret CONSTANT)

public:
    explicit CounterViewModel(QObject *parent = nullptr);

    int count() const;

    // --- ADD GETTERS ---
    QString clientId() const;
    QString clientSecret() const;

    Q_INVOKABLE void increment();
    Q_INVOKABLE void decrement();

signals:
    void countChanged();

private:
    std::shared_ptr<CounterService> m_service;
};
