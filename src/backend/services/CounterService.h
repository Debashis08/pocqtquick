#pragma once
#include "ICounterService.h" // Clean include thanks to CMake

class CounterService : public ICounterService
{
    Q_OBJECT
public:
    explicit CounterService(QObject* parent = nullptr);

    void increment() override;
    void decrement() override;
    int count() const override;

    std::string getClientId() const override;
    std::string getClientSecret() const override;

private:
    int _count;
};
