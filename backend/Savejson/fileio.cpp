#include <QStandardPaths>
#include "fileio.h"

FileIO::FileIO(QObject *parent) : QObject(parent)
{
}

FileIO::~FileIO()
{
}

void FileIO::read()
{
    if(m_path.isEmpty()) {
        return;
    }

//    QFile file(m_path.toLocalFile());
    QFile file(m_path.path());

    if(!file.exists()) {
        qWarning() << "Does not exits: " << m_path.toLocalFile();
        return;
    }
    if(file.open(QIODevice::ReadOnly)) {
        QTextStream stream(&file);
        m_text = stream.readAll();
        emit textChanged(m_text);
        qDebug() << "Text has been successfully read!";
    }
}

void FileIO::write()
{
    if(m_source.isEmpty()) {
        return;
    }

    qDebug() << "filename: " << m_path.fileName();
    qDebug() << "path: " << m_path.path();

    QFile file(m_path.path());
    qDebug() << "File path: " << file.fileName();

    if(file.open(QIODevice::WriteOnly)) {       
        QTextStream stream(&file);
        stream << m_text;
        qDebug() << "Successfully write to file";
    } else {
        qWarning() << "Failed to write to the file: " << m_path;
    }
}

QString FileIO::source() const
{
    return m_source;
}

QString FileIO::text()
{
    qDebug() << "Going to read the text";
    read();
    return m_text;
}

void FileIO::setSource(QString source)
{
    if (m_source == source)
        return;

    m_source = source;
    emit sourceChanged(source);

    // at the same time update the path
    m_path = QUrl(getFilePath(source));
}

void FileIO::setText(QString text)
{
    if (m_text == text)
        return;

    m_text = text;
    write();
    emit textChanged(text);
}

QString FileIO::getFilePath(const QString filename) const
{
//    QString APP_ID = getenv("APP_ID");
//    QString app_pkgname = APP_ID.split('_')[0];
//    QString path = getenv("XDG_DATA_HOME") +
//            "/" + app_pkgname + "/" + filename;
//    qDebug() << "path: " << path;
//    return path;

    QString writablePath = QStandardPaths::
            writableLocation(QStandardPaths::DataLocation);
    qDebug() << "writablePath: " << writablePath;

    QString absolutePath = QDir(writablePath).absolutePath();
    qDebug() << "absoluePath: " << absolutePath;

    // We need to make sure we have the path for storage
    QDir dir(absolutePath);
    if ( dir.mkdir(absolutePath) ) {
        qDebug() << "Successfully created the path!";
    }

    QString path = absolutePath + "/" + filename;

    qDebug() << "path: " << path;

    return path;
}

