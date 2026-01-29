#include "CounterService.h"
#include <QDebug>          // Needed for qInfo, qDebug

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
