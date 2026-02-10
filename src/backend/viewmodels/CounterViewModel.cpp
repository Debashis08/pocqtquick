#include "CounterViewModel.h"

CounterViewModel::CounterViewModel(QObject *parent) 
    : QObject(parent), m_service(nullptr), m_cachedCount(0) {}

ICounterService* CounterViewModel::service() const {
    return m_service;
}

void CounterViewModel::setService(ICounterService* newService) {
    if (m_service == newService) return;

    // Disconnect old
    if (m_service) disconnect(m_service, nullptr, this, nullptr);

    m_service = newService;
    emit serviceChanged();

    // Connect new
    if (m_service) {
        connect(m_service, &ICounterService::countChanged, 
                this, &CounterViewModel::onCountChanged);
        
        // Initialize state
        onCountChanged(m_service->count());
    }
}

void CounterViewModel::onCountChanged(int newCount) {
    m_cachedCount = newCount;
    emit countChanged();
}

int CounterViewModel::count() const {
    return m_cachedCount;
}

void CounterViewModel::increment() {
    if (m_service) m_service->increment();
}

void CounterViewModel::decrement() {
    if (m_service) m_service->decrement();
}

QString CounterViewModel::clientId() const {
    // Safety check is crucial because this IS called when m_service is null
    if (!m_service) return "Initializing...";
    return QString::fromStdString(m_service->getClientId());
}

QString CounterViewModel::clientSecret() const {
    if (!m_service) return "Initializing...";
    return QString::fromStdString(m_service->getClientSecret());
}
