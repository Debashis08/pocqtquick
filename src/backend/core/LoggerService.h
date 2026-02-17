#pragma once
#include <QString>
#include <QFile>
#include <QDir>
#include <QDateTime>
#include <QTextStream>
#include <iostream>

class LoggerService
{
public:
    // Call this once in main.cpp
    static void initialize();

private:
    // The actual handler that Qt calls
    static void messageHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg);

    // Helper to delete old files
    static void cleanOldLogs(const QString &logFolderPath);

    // Pointer to the current log file
    static QFile* _logFile;
};
