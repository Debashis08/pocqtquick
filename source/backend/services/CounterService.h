#pragma once

class CounterService {
public:
    CounterService();
    void increment();
    void decrement();
    int value() const;

private:
    int m_count;
};