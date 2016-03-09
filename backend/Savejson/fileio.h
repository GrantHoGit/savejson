#ifndef FILEIO_H
#define FILEIO_H

#include <QtCore>

class FileIO : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(FileIO)

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    FileIO(QObject *parent = 0);
    ~FileIO();

    Q_INVOKABLE void read();
    Q_INVOKABLE void write();
    QString source() const;
    QString text();

private:
    QString getFilePath(const QString filename) const;

public slots:
    void setSource(QString source);
    void setText(QString text);

signals:
    void sourceChanged(QUrl arg);
    void textChanged(QString arg);

private:
    QString m_source;
    QString m_text;
    QUrl m_path;
};

#endif // FILEIO_H

