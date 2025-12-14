#include "counter.h"

// Constructor: initializes the counter to 0.
Counter::Counter(QObject *parent)
    : QObject(parent), m_count(0)
{
}

// Getter for the count property.
int Counter::count() const
{
    return m_count;
}

// Increments the counter and emits the countChanged signal.
void Counter::increment()
{
    m_count++;
    emit countChanged();
}

// Resets the counter to 0 and emits the countChanged signal.
void Counter::reset()
{
    if (m_count != 0) {
        m_count = 0;
        emit countChanged();
    }
}
