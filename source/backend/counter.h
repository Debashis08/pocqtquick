#ifndef COUNTER_H
#define COUNTER_H

#include <QObject>

// The Counter class provides the backend logic for our QML frontend.
// It must inherit from QObject to leverage Qt's signals and slots mechanism.
class Counter : public QObject
{
    // Q_OBJECT macro is mandatory for any class that defines its own signals or slots.
    Q_OBJECT

    // Q_PROPERTY exposes a property to QML and other Qt systems.
    // READ: a getter function for the property.
    // NOTIFY: a signal that is emitted whenever the property's value changes.
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    // Explicit constructor.
    explicit Counter(QObject *parent = nullptr);

    // Getter function for the 'count' property.
    int count() const;

    // Q_INVOKABLE makes a C++ function callable from QML.
    Q_INVOKABLE void increment();
    Q_INVOKABLE void reset();

signals:
    // This signal is emitted when the 'count' property changes.
    // QML connections will react to this signal to update the UI.
    void countChanged();

private:
    // Member variable to store the current count.
    int m_count;
};

#endif // COUNTER_H
