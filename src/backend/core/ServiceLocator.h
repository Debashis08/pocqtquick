#pragma once
#include <memory>
#include "../services/CounterService.h"

class ServiceLocator {
public:
    // Global Access Point
    // this comment is to test the commit message parsing for the release drafter action
    static ServiceLocator& instance() {
        static ServiceLocator _instance;
        return _instance;
    }

    // The Dependencies
    std::shared_ptr<CounterService> counterService() {
        return m_counterService;
    }

private:
    ServiceLocator() {
        // Initialize the Singletons here
        m_counterService = std::make_shared<CounterService>();
    }
    
    // Delete copy constructors to ensure it's a true Singleton
    ServiceLocator(const ServiceLocator&) = delete;
    void operator=(const ServiceLocator&) = delete;

    std::shared_ptr<CounterService> m_counterService;
};