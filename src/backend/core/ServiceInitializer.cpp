#include "ServiceInitializer.h"
#include "ServiceProvider.h" // Update include!
#include "LoggerService.h"

void ServiceInitializer::initialize() {
    LoggerService::init();
    
    m_counterService = std::make_unique<CounterService>();
    
    // Inject into the new ServiceProvider
    ServiceProvider::instance().setCounterService(m_counterService.get());
}