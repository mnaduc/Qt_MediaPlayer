import QtQuick 2.9
import QtQuick.Controls 2.5

Drawer {
    interactive: false
    modal: false
    dim: false
    background: Image {
        id: playlistBgId
        source: 'images/playlist.png'
        anchors.fill: parent
    }
    ListView {
        id: mediaPlaylistId
        anchors.fill: parent
        model: myModel
        clip: true
        spacing: 2
        currentIndex: player.playlist.currentIndex
        delegate: MouseArea {
            width: mediaPlaylistId.width
            height: mediaPlaylistId.height / 5
            Image {
                id: playlistItemId
                source: ''
                opacity: 0.5
                anchors.fill: parent
            }
            Text {
                text: title||qsTr("STR_SONG_TITLE")
                color: 'white'
                font.pixelSize: 100
                fontSizeMode: Text.VerticalFit
                height: parent.height/4
                anchors.verticalCenter: parent.verticalCenter
                leftPadding:  2*parent.width / 17
            }
            onClicked: {
                player.playlist.currentIndex = index
            }
            onContainsPressChanged: {
                playlistItemId.source = containsPress ? 'images/hold.png':''
            }
        }
        highlight: Image {
            source: 'images/playlist_item.png'
            width: mediaPlaylistId.width
            height: mediaPlaylistId.height/5
            Image {
                source: 'images/playing.png'
                width: parent.width / 17
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: width/2
            }
        }
        ScrollBar.vertical: ScrollBar {
            parent: parent
        }
    }
    Item {
        width: mediaPlaylistId.width
        height: mediaPlaylistId.height / 5
        visible: mediaPlaylistId.count ? false : true
        Text {
            text: qsTr("STR_EMPTY_PLAYLIST")
            color: 'gray'
            font.pixelSize: 100
            fontSizeMode: Text.VerticalFit
            height: parent.height/4
            width: contentWidth
            anchors.centerIn: parent
        }
    }
}
