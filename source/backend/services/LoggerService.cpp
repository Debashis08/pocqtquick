#include "LoggerService.h"
#include <QCoreApplication>
#include <QStandardPaths>

QFile* LoggerService::m_logFile = nullptr;

void LoggerService::init() {
    // 1. Determine Log Folder Path (Same as before)
    QString appFolderPath = QCoreApplication::applicationDirPath();
    QDir logDir(appFolderPath);
    QString logPath = logDir.absoluteFilePath("logs");

    if (!logDir.exists("logs")) {
        logDir.mkpath("logs");
    }

    QDir finalLogDir(logPath);

    // 2. Cleanup Old Logs
    // (This still works perfectly; it will just delete files older than 10 days)
    cleanOldLogs(logPath);

    // -----------------------------------------------------------
    // CHANGE 1: Filename Format (Date Only)
    // -----------------------------------------------------------
    // Old: yyyy-MM-dd_HH-mm-ss
    // New: yyyy-MM-dd
    QString dateString = QDateTime::currentDateTime().toString("yyyy-MM-dd");
    QString fileName = finalLogDir.absoluteFilePath(QString("log_%1.txt").arg(dateString));

    m_logFile = new QFile(fileName);

    // -----------------------------------------------------------
    // CHANGE 2: Open Mode (Append)
    // -----------------------------------------------------------
    // QIODevice::Append ensures we don't delete previous logs from today
    if (m_logFile->open(QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text)) {

        // -----------------------------------------------------------
        // CHANGE 3: The "Session Separator"
        // -----------------------------------------------------------
        // Since we are appending, we need a visual line to see where this run started.
        QTextStream out(m_logFile);
        // out << "\n"; // Empty line for breathing room
        out << "--------------------------------------------------------------------\n";
        out << "   session start: " << QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss") << "\n";
        out << "--------------------------------------------------------------------\n";
        m_logFile->flush();

        qInstallMessageHandler(LoggerService::messageHandler);
    } else {
        // Handle error...
    }
}

void LoggerService::cleanOldLogs(const QString &logFolderPath) {
    QDir dir(logFolderPath);
    dir.setNameFilters(QStringList() << "log_*.txt");
    
    // Sort by time (Newest first)
    dir.setSorting(QDir::Time); 

    QFileInfoList fileList = dir.entryInfoList();

    // If more than 10 files, delete the oldest ones
    // Note: QDir::Time puts newest files at index 0.
    int maxLogs = 10;
    if (fileList.size() > maxLogs) {
        for (int i = maxLogs; i < fileList.size(); ++i) {
            QFile::remove(fileList.at(i).absoluteFilePath());
        }
    }
}

void LoggerService::messageHandler(QtMsgType type, const QMessageLogContext &context, const QString &msg) {
    // 1. Check if file is open
    if (!m_logFile) return;

    // ---------------------------------------------------------
    // UPDATE: Filter out Debug messages in Release Mode
    // ---------------------------------------------------------
#ifdef QT_NO_DEBUG
    // If this is a RELEASE build, and the message is a Debug log,
    // ignore it immediately. This keeps log files clean and small.
    if (type == QtDebugMsg) {
        return;
    }
#endif
    // ---------------------------------------------------------

    // 2. Determine Log Level
    QString levelText;
    switch (type) {
        case QtDebugMsg:    levelText = "DEBUG"; break;
        case QtInfoMsg:     levelText = "INFO "; break;
        case QtWarningMsg:  levelText = "WARN "; break;
        case QtCriticalMsg: levelText = "CRIT "; break;
        case QtFatalMsg:    levelText = "FATAL"; break;
    }

    // 3. Format the message
    // Format: [YYYY-MM-DD HH:mm:ss] [LEVEL] Message (File:Line)
    QString timestamp = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");
    QString formattedMsg = QString("[%1] [%2] %3")
                               .arg(timestamp, levelText, msg);

    // 4. Write to File
    QTextStream out(m_logFile);
    out << formattedMsg << "\n";
    m_logFile->flush(); // Ensure it's written immediately in case of crash

    // 5. Also write to standard Console (so you can still see it in Qt Creator)
    std::cout << formattedMsg.toStdString() << std::endl;
}
