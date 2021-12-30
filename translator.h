#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QObject>
#include <QTranslator>

QT_BEGIN_NAMESPACE
class QGuiApplication;
QT_END_NAMESPACE

class Translator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)
public:
    explicit Translator(QObject *parent = nullptr);

    const QString &language() const;
    void setLanguage(const QString &newLanguage);

signals:
    void languageChanged();

private:
    QTranslator m_translator;
    QGuiApplication *m_app;
    QString m_language;
};

#endif // TRANSLATOR_H
