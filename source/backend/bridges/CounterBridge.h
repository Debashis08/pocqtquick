#pragma once
#include <QObject>
#include <QtQml/qqmlregistration.h>
#include "services/CounterService.h"

class CounterBridge : public QObject {
    Q_OBJECT
    QML_ELEMENT // Registers this class to QML automatically
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    explicit CounterBridge(QObject *parent = nullptr);

    int count() const;

    Q_INVOKABLE void increment();
    Q_INVOKABLE void decrement();

signals:
    void countChanged();

private:
    CounterService m_service; // Composition: The Bridge owns the Service
};