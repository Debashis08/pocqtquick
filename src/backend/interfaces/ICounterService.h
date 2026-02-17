#pragma once
#include <QObject>
#include <string>

class ICounterService : public QObject
{
    Q_OBJECT
public:
    virtual ~ICounterService() = default;

    // Pure Virtual Methods
    virtual void increment() = 0;
    virtual void decrement() = 0;
    virtual int count() const = 0;
    
    // Config Methods
    virtual std::string getClientId() const = 0;
    virtual std::string getClientSecret() const = 0;

signals:
    void countChanged(int newCount);

protected:
    explicit ICounterService(QObject* parent = nullptr) : QObject(parent) {}
};
