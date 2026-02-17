#include "ServiceInitializer.h"
#include "ServiceProvider.h" // Update include!
#include "LoggerService.h"

void ServiceInitializer::initialize()
{
    LoggerService::initialize();
    
    _counterService = std::make_unique<CounterService>();
    
    // Inject into the new ServiceProvider
    ServiceProvider::instance().setCounterService(_counterService.get());
}
