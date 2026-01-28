#include "LoggerService.h"
#include <QCoreApplication>
#include <QStandardPaths>

QFile* LoggerService::m_logFile = nullptr;

void LoggerService::init() {
    // 1. Determine Log Folder Path
    // Get the folder containing the .exe (e.g., C:\Program Files\MyApp)
    QString appFolderPath = QCoreApplication::applicationDirPath();

    // Construct path directly inside that folder
    QDir logDir(appFolderPath);
    QString logPath = logDir.absoluteFilePath("logs"); // Result: C:\Program Files\MyApp\logs

    // -------------------------------------------------------------
    // CRITICAL WARNING FOR INSTALLERS:
    // If your user installs this to "C:\Program Files", this WILL FAIL.
    // Standard users cannot write to Program Files.
    // -------------------------------------------------------------

    // 2. Create Directory if it doesn't exist
    if (!logDir.exists("logs")) {
        logDir.mkpath("logs");
    }

    // Update logPath to point inside the new folder
    // (Re-using the variable purely for the file logic below)
    QDir finalLogDir(logPath);

    // ... (Rest of your code: cleanupOldLogs, Create File) ...

    // 3. Cleanup Old Logs (Keep last 10)
    cleanOldLogs(logPath);

    // 4. Create New Log File
    QString timestamp = QDateTime::currentDateTime().toString("yyyy-MM-dd_HH-mm-ss");
    QString fileName = finalLogDir.absoluteFilePath(QString("log_%1.txt").arg(timestamp));

    m_logFile = new QFile(fileName);

    // Debugging Tool: Show a Message Box if file creation fails
    if (m_logFile->open(QIODevice::WriteOnly | QIODevice::Text)) {
        qInstallMessageHandler(LoggerService::messageHandler);
    } else {
        // Since we don't have a console in the installed app,
        // we should try to alert (or at least we know why it failed).
        // Common cause: "Access is denied" in C:\Program Files
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
