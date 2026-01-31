#include "CounterViewModel.h"
#include "core/ServiceLocator.h" // Include the locator

CounterViewModel::CounterViewModel(QObject *parent) : QObject(parent) {
    // "Inject" the dependency by asking the locator
    m_service = ServiceLocator::instance().counterService();
}

int CounterViewModel::count() const {
    // Access via pointer (->) instead of dot (.)
    return m_service->value();
}

void CounterViewModel::increment() {
    m_service->increment();
    emit countChanged(); // Tell QML to update
}

void CounterViewModel::decrement() {
    m_service->decrement();
    emit countChanged();
}

QString CounterViewModel::clientId() const {
    // Option A: Return macro defined by CMake
    // return CLIENT_ID;

    // Option B: Get from your service
    return QString::fromStdString(m_service->getClientId());
}

QString CounterViewModel::clientSecret() const {
    return QString::fromStdString(m_service->getClientSecret());
}
