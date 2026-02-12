#include "CounterService.h"
#include <QDebug>

// Fallbacks for Secrets
#ifndef CLIENT_ID
    #define CLIENT_ID "default_id_placeholder"
#endif
#ifndef CLIENT_SECRET
    #define CLIENT_SECRET "default_secret_placeholder"
#endif

CounterService::CounterService(QObject* parent) 
    : ICounterService(parent), m_count(0) {}

void CounterService::increment() {
    m_count++;
    qInfo() << "Counter incremented to" << m_count;
    emit countChanged(m_count); // Emit signal defined in Interface
}

void CounterService::decrement() {
    m_count--;
    qInfo() << "Counter decremented to" << m_count;
    emit countChanged(m_count);
}

int CounterService::count() const {
    return m_count;
}

std::string CounterService::getClientId() const {
    return CLIENT_ID;
}

std::string CounterService::getClientSecret() const {
    return CLIENT_SECRET;
}