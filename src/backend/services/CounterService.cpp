#include "CounterService.h"
#include <QDebug>

// Fallbacks for Secrets
#ifndef CLIENT_ID
    #define CLIENT_ID "default_client_id_placeholder"
#endif
#ifndef CLIENT_SECRET
    #define CLIENT_SECRET "default_client_secret_placeholder"
#endif

CounterService::CounterService(QObject* parent) : ICounterService(parent), _count(0) {}

void CounterService::increment()
{
    _count++;
    qInfo() << "Counter incremented to" << _count;
    // Emit signal defined in Interface
    emit countChanged(_count);
}

void CounterService::decrement()
{
    _count--;
    qInfo() << "Counter decremented to" << _count;
    emit countChanged(_count);
}

int CounterService::count() const
{
    return _count;
}

std::string CounterService::getClientId() const
{
    return CLIENT_ID;
}

std::string CounterService::getClientSecret() const
{
    return CLIENT_SECRET;
}
