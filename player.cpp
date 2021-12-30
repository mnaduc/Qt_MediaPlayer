#include "player.h"
#include "playlistmodel.h"
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QDir>
#include <QStandardPaths>
#include <QTemporaryDir>
#include <QTime>

#include <tag.h>
#include <fileref.h>
#include <id3v2tag.h>
#include <mpegfile.h>
#include <id3v2frame.h>
#include <id3v2header.h>
#include <attachedpictureframe.h>


using namespace TagLib;

Player::Player(QObject *parent) : QObject(parent)
  ,m_shuffle(false)
  ,m_repeat(false)
  ,m_media_player(new QMediaPlayer(this))
  ,m_media_playlist(new QMediaPlaylist(this))
  ,m_playlist_model(new PlaylistModel(this))
  ,temp_dir(new QTemporaryDir)
{
    qDebug() << temp_dir->path();
    m_media_player->setPlaylist(m_media_playlist);
    loadMp3();
    if (!m_media_playlist->isEmpty()) m_media_playlist->setCurrentIndex(0);
    connect(m_media_player, &QMediaPlayer::mediaStatusChanged, this, [&](){
        // End Of Media
        if (m_media_player->mediaStatus() == QMediaPlayer::EndOfMedia)
        {
            if (m_repeat)
                m_media_playlist->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
            else
            {
                if (m_shuffle)
                    playRandom();
                else
                {
                   m_media_playlist->setPlaybackMode(QMediaPlaylist::Sequential);
                   m_media_playlist->next();
                }
            }
        }
    });
}

Player::~Player()
{
    delete temp_dir;
}

QMediaPlayer *Player::mediaPlayer() const
{
    return m_media_player;
}

QMediaPlaylist *Player::mediaPlaylist() const
{
    return m_media_playlist;
}

PlaylistModel *Player::playlist_model() const
{
    return m_playlist_model;
}

QString Player::getTimeInfo(qint64 time)
{
    time = time/1000;
    qint64 durarion = m_media_player->duration();
    QString format = (durarion > 3600000) ? "hh::mm:ss":"mm:ss";
    QTime currentTime((time / 3600) % 60, (time / 60) % 60, time % 60, (time * 1000) % 1000);
    return currentTime.toString(format);
}

bool Player::shuffle() const
{
    return m_shuffle;
}

void Player::setShuffle(bool newShuffle)
{
    if (m_shuffle == newShuffle)
        return;
    m_shuffle = newShuffle;
    emit shuffleChanged();
}

bool Player::repeat() const
{
    return m_repeat;
}

void Player::setRepeat(bool newRepeat)
{
    if (m_repeat == newRepeat)
        return;
    m_repeat = newRepeat;
    emit repeatChanged();
}

void Player::next()
{
    qDebug() << "next";
    if (m_shuffle)
        playRandom();
    else
    {
        m_media_playlist->setPlaybackMode(QMediaPlaylist::Sequential);
        if (m_media_playlist->currentIndex() == m_media_playlist->mediaCount()-1)
            m_media_playlist->setCurrentIndex(0);
        else
            m_media_playlist->next();
    }
    m_media_player->play();
}

void Player::previous()
{
    qDebug() << "previous";
    if (m_shuffle)
        playRandom();
    else
    {
        m_media_playlist->setPlaybackMode(QMediaPlaylist::Sequential);
        if (m_media_playlist->currentIndex() == 0)
            m_media_playlist->setCurrentIndex(m_media_playlist->mediaCount()-1);
        else
            m_media_playlist->previous();
    }
    m_media_player->play();
}

void Player::loadMp3()
{
    QDir dir(QStandardPaths::standardLocations(QStandardPaths::MusicLocation).at(0));
    QFileInfoList musics = dir.entryInfoList(QStringList() << "*.mp3", QDir::Files);
    QList<QUrl> urls;
    for (auto &music : musics)
    {
        urls.append(QUrl::fromLocalFile(music.filePath()));
    }
    addToPlayList(urls);
}

void Player::addToPlayList(const QList<QUrl> &urls)
{
    for (auto &url : urls)
    {
        QString album_art_url = getAlbumArt(url);
        m_media_playlist->addMedia(url);
        FileRef f(url.toLocalFile().toStdString().c_str());
        Tag *tag = f.tag();
        Song song(QString::fromWCharArray(tag->title().toCWString()),
                  QString::fromWCharArray(tag->artist().toCWString()),
                  url.toLocalFile(),
                  album_art_url);
        m_playlist_model->addSong(song);

    }
}


QString Player::getAlbumArt(QUrl url)
{
    static const char *IdPicture = "APIC" ;
    MPEG::File mpegFile(url.toLocalFile().toStdString().c_str());
    ID3v2::Tag *id3v2tag = mpegFile.ID3v2Tag();
    ID3v2::FrameList Frame ;
    ID3v2::AttachedPictureFrame *PicFrame ;
    void *SrcImage ;
    unsigned long Size ;

    FILE *pngFile;

    if ( id3v2tag )
    {
        // picture frame
        Frame = id3v2tag->frameListMap()[IdPicture] ;
        if (!Frame.isEmpty())
        {
            for(TagLib::ID3v2::FrameList::ConstIterator it = Frame.begin(); it != Frame.end(); ++it)
            {
                PicFrame = static_cast<TagLib::ID3v2::AttachedPictureFrame*>(*it) ;
                if ( PicFrame->type() == TagLib::ID3v2::AttachedPictureFrame::FrontCover)
                {
                    QString jpgFile_url = temp_dir->filePath(url.fileName()+".jpg");
                    pngFile = fopen(jpgFile_url.toStdString().c_str(),"wb");
                    // extract image (in it’s compressed form)
                    Size = PicFrame->picture().size() ;
                    SrcImage = malloc ( Size ) ;
                    if ( SrcImage )
                    {
                        memcpy ( SrcImage, PicFrame->picture().data(), Size ) ;
                        fwrite(SrcImage,Size,1, pngFile);
                        fclose(pngFile);
                        free(SrcImage) ;
                        return QUrl::fromLocalFile(jpgFile_url).toDisplayString();
                    }
                }
            }
        }
    }
    else
    {
        qDebug() <<"id3v2 not present";
        return "qrc:images/album_art.png";
    }
    return "qrc:images/album_art.png";
}


void Player::playRandom()
{
    m_media_playlist->setPlaybackMode(QMediaPlaylist::Random);
    if (m_media_playlist->mediaCount() > 1)
    {
        int last_index = m_media_playlist->currentIndex();
        while (last_index == m_media_playlist->currentIndex())
            m_media_playlist->next();
    }
}
