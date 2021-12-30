#ifndef PLAYLISTMODEL_H
#define PLAYLISTMODEL_H

#include <QAbstractListModel>

class Song
{
public:
    Song (const QString &title, const QString &singer, const QString &source, const QString &album_art);
    QString title() const;
    QString singer() const;
    QString source() const;
    QString album_art() const;

private:
    QString m_title;
    QString m_singer;
    QString m_source;
    QString m_album_art;
};


class PlaylistModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles
    {
        TitleRole = Qt::UserRole + 1,
        SingerRole,
        SourceRole,
        AlbumArtRole
    };
    explicit PlaylistModel(QObject *parent = nullptr);
    void addSong(const Song &song);
    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QList<Song> m_data;
};

#endif // PLAYLISTMODEL_H
