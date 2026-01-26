#include "CounterBridge.h"

CounterBridge::CounterBridge(QObject *parent) : QObject(parent) {}

int CounterBridge::count() const {
    return m_service.value();
}

void CounterBridge::increment() {
    m_service.increment();
    emit countChanged(); // Tell QML to update
}

void CounterBridge::decrement() {
    m_service.decrement();
    emit countChanged();
}