#include "ServiceProvider.h"

ServiceProvider& ServiceProvider::instance()
{
    static ServiceProvider s_instance;
    return s_instance;
}

ServiceProvider* ServiceProvider::create(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(qmlEngine)
    Q_UNUSED(jsEngine)
    QJSEngine::setObjectOwnership(&instance(), QJSEngine::CppOwnership);
    return &instance();
}

void ServiceProvider::setCounterService(ICounterService* service)
{
    _counterService = service;
}

ICounterService* ServiceProvider::counter() const
{
    return _counterService;
}
