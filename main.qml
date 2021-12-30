import QtQuick 2.9
import QtQuick.Controls 2.5

ApplicationWindow {
    width: 1920/2
    height: 1080/2
    visible: true
//    visibility: "FullScreen"
    title: qsTr("STR_MAIN_TITLE")

    //Backgroud of Application
    Image {
        source: 'images/background.png'
        anchors.fill: parent
    }
    //Header
    AppHeader {
        id: headerItemId
        width: parent.width
        height: 0.13 * parent.height
        playlistBtnStatus: playlistId.opened ? false:true
        onClickedPlayListBtn: playlistId.opened ? playlistId.close():playlistId.open()
    }
    //Playlist
    PlaylistView {
        id: playlistId
        y: headerItemId.height
        width: 0.35 * parent.width
        height: parent.height - headerItemId.height

    }
    //Media Info
    MediaInfoControl {
        anchors.bottom: parent.bottom
        anchors.top: headerItemId.bottom
        anchors.right: parent.right
        width: parent.width - playlistId.position * playlistId.width
    }
}
