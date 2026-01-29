#include "CounterService.h"
#include <QDebug>          // Needed for qInfo, qDebug

CounterService::CounterService() : m_count(0) {}

void CounterService::increment() {
    m_count++;
    qInfo()<<"Counter incremented. New Value"<<m_count;
}

void CounterService::decrement() {
    m_count--;
    qCritical()<<"Counter decremented. New Value"<<m_count;
}

int CounterService::value() const {
    return m_count;
}
