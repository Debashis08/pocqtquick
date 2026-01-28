#include "CounterService.h"

CounterService::CounterService() : m_count(0) {}

void CounterService::increment() {
    m_count++;
}

void CounterService::decrement() {
    m_count--;
}

int CounterService::value() const {
    return m_count;
}