#pragma once
#include <string> // Required for std::string

class CounterService {
public:
    CounterService();

    void increment();
    void decrement();
    int value() const;

    // --- ADD THESE ---
    std::string getClientId() const;
    std::string getClientSecret() const;

private:
    int m_count;
};
