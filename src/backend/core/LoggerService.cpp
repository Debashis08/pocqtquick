#include "LoggerService.h"
#include <QCoreApplication>
#include <QStandardPaths>

QFile* LoggerService::_logFile = nullptr;

void LoggerService::initialize()
{
    // Determine Log Folder Path
    QString appFolderPath = QCoreApplication::applicationDirPath();
    QDir logDir(appFolderPath);
    QString logPath = logDir.absoluteFilePath("logs");

    if (!logDir.exists("logs"))
    {
        logDir.mkpath("logs");
    }

    QDir finalLogDir(logPath);

    // Cleanup Old Logs
    cleanOldLogs(logPath);

    // Filename Format yyyy-MM-dd
    QString dateString = QDateTime::currentDateTime().toString("yyyy-MM-dd");
    QString fileName = finalLogDir.absoluteFilePath(QString("log_%1.txt").arg(dateString));

    _logFile = new QFile(fileName);

    // Open the file in append mode
    // QIODevice::Append ensures we don't delete previous logs from today
    if (_logFile->open(QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text))
    {
        // session separator
        // Since we are appending, we need a visual line to see where this run started.
        QTextStream out(_logFile);
        out << "--------------------------------------------------------------------\n";
        out << "session start: " << QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss") << "\n";
        out << "--------------------------------------------------------------------\n";
        _logFile->flush();

        qInstallMessageHandler(LoggerService::messageHandler);
    }
    else
    {
        // Handle error...
    }
}

void LoggerService::cleanOldLogs(const QString &logFolderPath)
{
    QDir dir(logFolderPath);
    dir.setNameFilters(QStringList() << "log_*.txt");
    
    // Sort by time (Newest first)
    dir.setSorting(QDir::Time); 

    QFileInfoList fileList = dir.entryInfoList();

    // If more than 10 files, delete the oldest ones
    // Note: QDir::Time puts newest files at index 0.
    int maxLogs = 10;
    if (fileList.size() > maxLogs)
    {
        for (int i = maxLogs; i < fileList.size(); ++i)
        {
            QFile::remove(fileList.at(i).absoluteFilePath());
        }
    }
}

void LoggerService::messageHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    // Check if file is open
    if (!_logFile) return;

    // Filter out Debug messages in Release Mode
#ifdef QT_NO_DEBUG
    // If this is a RELEASE build, and the message is a Debug log,
    // ignore it immediately. This keeps log files clean and small.
    if (type == QtDebugMsg)
    {
        return;
    }
#endif
    // Determine Log Level
    QString levelText;
    switch (type)
    {
        case QtDebugMsg:    levelText = "DEBUG"; break;
        case QtInfoMsg:     levelText = "INFO "; break;
        case QtWarningMsg:  levelText = "WARN "; break;
        case QtCriticalMsg: levelText = "CRIT "; break;
        case QtFatalMsg:    levelText = "FATAL"; break;
    }

    // Format the message
    // Format: [YYYY-MM-DD HH:mm:ss] [LEVEL] Message
    QString timestamp = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");
    QString formattedMsg = QString("[%1] [%2] %3").arg(timestamp, levelText, msg);

    // Write to File
    QTextStream out(_logFile);
    out << formattedMsg << "\n";
    // Ensure it is written immediately in case of crash
    _logFile->flush();

    // Also write to standard Console
    std::cout << formattedMsg.toStdString() << std::endl;
}
