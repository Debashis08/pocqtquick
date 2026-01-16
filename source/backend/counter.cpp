#include "counter.h"

#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)

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

QString Counter::clientId() const
{
    // APP_GOOGLE_CLIENT_ID is defined in source/CMakeLists.txt
#ifdef APP_GOOGLE_CLIENT_ID
    return QStringLiteral(TOSTRING(APP_GOOGLE_CLIENT_ID));
#else
    return QString(""); // Return empty if not found
#endif
}

QString Counter::clientSecret() const
{
#ifdef APP_GOOGLE_CLIENT_SECRET
    return QStringLiteral(TOSTRING(APP_GOOGLE_CLIENT_SECRET));
#else
    return QString("");
#endif
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
