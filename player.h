#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>

QT_BEGIN_NAMESPACE
class QMediaPlayer;
class QMediaPlaylist;
class QTemporaryDir;
QT_END_NAMESPACE
class PlaylistModel;


class Player : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool shuffle READ shuffle WRITE setShuffle NOTIFY shuffleChanged)
    Q_PROPERTY(bool repeat READ repeat WRITE setRepeat NOTIFY repeatChanged)
public:
    explicit Player(QObject *parent = nullptr);
    ~Player();

    QMediaPlayer *mediaPlayer() const;
    QMediaPlaylist *mediaPlaylist() const;
    PlaylistModel *playlist_model() const;
    Q_INVOKABLE QString getTimeInfo(qint64 time);

    bool shuffle() const;
    void setShuffle(bool newShuffle);
    bool repeat() const;
    void setRepeat(bool newRepeat);

signals:
    void shuffleChanged();
    void repeatChanged();

public slots:
    void next();
    void previous();

private:
    bool m_shuffle;
    bool m_repeat;
    QMediaPlayer *m_media_player;
    QMediaPlaylist *m_media_playlist;
    PlaylistModel *m_playlist_model;
    QTemporaryDir *temp_dir;

    void loadMp3();
    void addToPlayList(const QList<QUrl> &urls);
    QString getAlbumArt(QUrl url);
    void playRandom();
};

#endif // PLAYER_H
