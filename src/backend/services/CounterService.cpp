#include "CounterService.h"
#include <QDebug>          // Needed for qInfo, qDebug

// If these macros aren't defined by CMake, provide fallback strings
#ifndef CLIENT_ID
    #define CLIENT_ID "default_id_placeholder"
#endif

#ifndef CLIENT_SECRET
    #define CLIENT_SECRET "default_secret_placeholder"
#endif

CounterService::CounterService() : m_count(0) {}

void CounterService::increment() {
    qDebug()<<"CounterService - increment started";
    m_count++;
    qInfo()<<"Counter incremented. New Value"<<m_count;
    qDebug()<<"CounterService - increment finished";
}

void CounterService::decrement() {
    qDebug()<<"CounterService - decrement started";
    m_count--;
    qCritical()<<"Counter decremented. New Value"<<m_count;
    qDebug()<<"CounterService - decrement finished";
}

int CounterService::value() const {
    return m_count;
}

// --- NEW IMPLEMENTATIONS ---

std::string CounterService::getClientId() const {
    // Returns the value injected by the compiler/CMake
    return CLIENT_ID;
}

std::string CounterService::getClientSecret() const {
    // Returns the value injected by the compiler/CMake
    return CLIENT_SECRET;
}
