#include "translator.h"
#include <QGuiApplication>

Translator::Translator(QObject *parent)
    : QObject(parent)
{
    setLanguage("vn");
}

const QString &Translator::language() const
{
    return m_language;
}

void Translator::setLanguage(const QString &newLanguage)
{
    if (m_language == newLanguage)
        return;
    if (newLanguage == "vn")
        m_translator.load(":/translator/translate_vn.qm");
    else if ( newLanguage == "us")
        m_translator.load(":/translator/translate_us.qm");
    else
        return;
    m_language = newLanguage;
    m_app->installTranslator(&m_translator);
    emit languageChanged();
}
