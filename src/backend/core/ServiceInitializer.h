#pragma once
#include <memory>
#include "services/CounterService.h"

// The new name for AppBootstrapper
class ServiceInitializer
{
public:
    void initialize();

private:
    std::unique_ptr<CounterService> _counterService;
};
