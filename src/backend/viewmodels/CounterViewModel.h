#pragma once
#include <QObject>
#include <QQmlEngine>
#include "ICounterService.h" 

class CounterViewModel : public QObject {
    Q_OBJECT
    QML_ELEMENT
    
    // 1. Dependency Injection Slot
    Q_PROPERTY(ICounterService* service READ service WRITE setService NOTIFY serviceChanged)

    // 2. UI Properties
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QString clientId READ clientId NOTIFY serviceChanged)
    Q_PROPERTY(QString clientSecret READ clientSecret NOTIFY serviceChanged)

public:
    explicit CounterViewModel(QObject *parent = nullptr);

    // Dependency Setter
    void setService(ICounterService* service);
    ICounterService* service() const;

    // Getters for UI
    int count() const;
    QString clientId() const;
    QString clientSecret() const;

    Q_INVOKABLE void increment();
    Q_INVOKABLE void decrement();

public slots:
    void onCountChanged(int newCount);

signals:
    void serviceChanged();
    void countChanged();

private:
    ICounterService* m_service;
    int m_cachedCount; // Optional: Local cache for fast UI reads
};
