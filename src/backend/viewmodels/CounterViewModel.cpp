#include <QDebug>
#include "CounterViewModel.h"

CounterViewModel::CounterViewModel(QObject *parent) : QObject(parent), _service(nullptr), _cachedCount(0) {}

ICounterService* CounterViewModel::service() const
{
    return _service;
}

void CounterViewModel::setService(ICounterService* newService)
{
    if (_service == newService) return;

    // Disconnect old
    if (_service) disconnect(_service, nullptr, this, nullptr);

    _service = newService;

    // Connect new
    if (_service)
    {
        bool isSuccess = connect(_service, &ICounterService::countChanged, this, &CounterViewModel::onCountChanged);
        qDebug()<< "Connection status"<<isSuccess;
        
        // Initialize state
        onCountChanged(_service->count());
    }

    emit serviceChanged();
}

void CounterViewModel::onCountChanged(int newCount)
{
    _cachedCount = newCount;
    emit countChanged();
}

int CounterViewModel::count() const
{
    return _cachedCount;
}

void CounterViewModel::increment()
{
    if (_service) _service->increment();
}

void CounterViewModel::decrement()
{
    if (_service) _service->decrement();
}

QString CounterViewModel::clientId() const
{
    // Safety check is crucial because this is called when _service is null
    if (!_service) return "No Service";
    return QString::fromStdString(_service->getClientId());
}

QString CounterViewModel::clientSecret() const
{
    if (!_service) return "No Service";
    return QString::fromStdString(_service->getClientSecret());
}
