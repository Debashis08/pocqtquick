#include "CounterBridge.h"
#include "core/ServiceLocator.h" // Include the locator

CounterBridge::CounterBridge(QObject *parent) : QObject(parent) {
    // "Inject" the dependency by asking the locator
    m_service = ServiceLocator::instance().counterService();
}

int CounterBridge::count() const {
    // Access via pointer (->) instead of dot (.)
    return m_service->value();
}

void CounterBridge::increment() {
    m_service->increment();
    emit countChanged(); // Tell QML to update
}

void CounterBridge::decrement() {
    m_service->decrement();
    emit countChanged();
}