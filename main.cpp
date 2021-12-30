#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QMediaPlayer>
#include <QMediaPlaylist>

#include "player.h"
#include "playlistmodel.h"
#include "translator.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    qRegisterMetaType<QMediaPlaylist*>("QMediaPlaylist*");

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    Translator translator;
    QObject::connect(&translator, &Translator::languageChanged,
                     &engine, &QQmlApplicationEngine::retranslate);

    Player player;
    engine.rootContext()->setContextProperty("Translator", &translator);
    engine.rootContext()->setContextProperty("myModel", player.playlist_model());
    engine.rootContext()->setContextProperty("player", player.mediaPlayer());
    engine.rootContext()->setContextProperty("utility", &player);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
