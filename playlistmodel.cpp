#include "playlistmodel.h"
#include <QDebug>

Song::Song(const QString &title, const QString &singer, const QString &source, const QString &album_art)
{
    m_title = title;
    m_singer = singer;
    m_source = source;
    m_album_art = album_art;
}

QString Song::title() const
{
    return m_title;
}

QString Song::singer() const
{
    return m_singer;
}

QString Song::source() const
{
    return m_source;
}

QString Song::album_art() const
{
    return m_album_art;
}

PlaylistModel::PlaylistModel(QObject *parent) : QAbstractListModel(parent)
{}

void PlaylistModel::addSong(const Song &song)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_data << song;
    endInsertRows();
}

int PlaylistModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_data.count();
}

QVariant PlaylistModel::data(const QModelIndex &index, int role) const
{
    if(index.row() < 0 || index.row() >= m_data.count())
        return QVariant();
    const Song &song = m_data.at(index.row());
    if (role == TitleRole)
        return song.title();
    else if (role == SingerRole )
        return song.singer();
    else if (role == SourceRole)
        return song.source();
    else if (role == AlbumArtRole)
        return song.album_art();
    return QVariant();
}

QHash<int, QByteArray> PlaylistModel::roleNames() const
{
    QHash <int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[SingerRole] = "singer";
    roles[SourceRole] = "source";
    roles[AlbumArtRole] = "albumArt";
    return roles;
}
