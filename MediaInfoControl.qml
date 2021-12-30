import QtQuick 2.9
import QtQuick.Controls 2.5
import QtMultimedia 5.9

Item {
    // Info
    Text {
        id: audioTitleTxtId
        text: !!albumArtId.currentItem ? (albumArtId.currentItem.modelItem.title||qsTr("STR_SONG_TITLE")) : ""
        color: 'white'
        font.pixelSize: 100
        height: parent.height/18
        fontSizeMode: Text.VerticalFit
        anchors {
            top: parent.top
            left: parent.left
            topMargin: height/3
            leftMargin: anchors.topMargin
        }
        onTextChanged: textChangeAniId.restart()
    }
    Text {
        id: audioSingerTxtId
        text: !!albumArtId.currentItem ? (albumArtId.currentItem.modelItem.singer||qsTr("STR_SINGER")) : ""
        color: 'white'
        font.pixelSize: audioTitleTxtId.fontInfo.pixelSize /1.2
        height: audioTitleTxtId.height
        anchors.top: audioTitleTxtId.bottom
        anchors.left: audioTitleTxtId.left
    }
    NumberAnimation {
        id: textChangeAniId
        targets: [audioTitleTxtId, audioSingerTxtId]
        properties: "opacity"
        from: 0
        to: 1
        duration: 600
        easing.type: Easing.InOutQuart
    }
    Text {
        id: audioCountTxtId
        text: albumArtId.count
        color: 'white'
        font.pixelSize: 100
        height: audioTitleTxtId.height
        width: contentWidth
        fontSizeMode: Text.VerticalFit
        anchors.top: audioTitleTxtId.top
        anchors.right: parent.right
        anchors.rightMargin: height/3
        Image {
            source: 'images/music.png'
            height: parent.height / 1.4
            fillMode: Image.PreserveAspectFit
            anchors.right: parent.left
            anchors.rightMargin: height / 5
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    //Album Art
    PathView {
        id:albumArtId
        anchors.top: audioSingerTxtId.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height/2
        width: Math.min(height*3, parent.width*0.85)
        model: myModel
        currentIndex: player.playlist.currentIndex
        delegate: Image {
            property variant modelItem : model
            source: albumArt
            width: albumArtId.width / 3
            height: width
            fillMode: Image.PreserveAspectCrop
            scale: PathView.iconScale || 1
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    player.playlist.currentIndex = index
                }
            }
        }
        pathItemCount: 3
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        path: Path {
            startX: 0; startY: albumArtId.height/2
            PathAttribute { name: 'iconScale'; value: 0.5 }
            PathLine {x:albumArtId.width/2; y:albumArtId.height/2}
            PathAttribute { name: 'iconScale'; value: 1 }
            PathLine {x:albumArtId.width; y:albumArtId.height/2}
            PathAttribute { name: 'iconScale'; value: 0.5 }
        }
        onMovementEnded: {
            player.playlist.currentIndex = currentIndex
        }
    }
    Text {
        color: "gray"
        text: qsTr("STR_EMPTY_PLAYLIST")
        visible: albumArtId.count ? false : true
        font.pixelSize: 100
        height: albumArtId.height/9
        width: contentWidth
        fontSizeMode: Text.VerticalFit
        anchors.centerIn: albumArtId
    }

    // Progress Bar
    Slider {
        id: progressBarId
        from: 0
        to: player.duration
        value: pressed ? value : player.position
        width: parent.width * 0.8
        height: parent.height/50
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: albumArtId.bottom
            topMargin: parent.height/20
        }
        background: Image {
            id: progressBarBgId
            source: 'images/progress_bar_bg.png'
            anchors.centerIn: parent
            width: parent.availableWidth
            height: parent.height / 3
            Image {
                source: 'images/progress_bar.png'
                width: progressBarId.visualPosition * parent.width
                height: parent.height
            }
        }
        handle: Image {
            source: 'images/point.png'
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 2
            width: height
            x: progressBarId.leftPadding + progressBarId.visualPosition * (progressBarId.availableWidth - width)
            Image {
                source: 'images/center_point.png'
                anchors.centerIn: parent
                height: parent.height/1.5
                width: height
            }
        }
        onPressedChanged: {
            if (!pressed && player.seekable)
                player.setPosition(value)
        }
    }
    Text {
        id: currentTimeId
        text: !!utility ? utility.getTimeInfo(progressBarId.value) : "00:00"
        color: 'white'
        font.pointSize: 100
        fontSizeMode: Text.VerticalFit
        height: progressBarId.height*1.6
        width: contentWidth
        verticalAlignment: Text.AlignVCenter
        anchors.right: progressBarId.left
        anchors.rightMargin: width/5
        anchors.verticalCenter: progressBarId.verticalCenter
    }
    Text {
        id: totalTimeId
        text: !!utility ? utility.getTimeInfo(player.duration) : "00:00"
        color: 'white'
        font.pixelSize: currentTimeId.fontInfo.pixelSize
        anchors.left: progressBarId.right
        anchors.leftMargin: width/5
        anchors.verticalCenter: progressBarId.verticalCenter
    }

    //Media control
    ButtonControl {
        id: mainBtnId
        icon_default: player.state === MediaPlayer.PlayingState ?  'images/pause' : 'images/play.png'
        icon_pressed: player.state === MediaPlayer.PlayingState ? 'images/hold-pause.png':'images/hold-play.png'
        height: parent.height / 8
        width: height
        anchors.top: progressBarId.bottom
        anchors.topMargin: height/3
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            if (player.state !== MediaPlayer.PlayingState){
                player.play()
            } else {
                player.pause()
            }
        }
        Connections {
            target: player
            onStateChanged: {
                mainBtnId.source = player.state === MediaPlayer.PlayingState ?  "qrc:/images/pause.png" : "qrc:/images/play.png"
            }
        }
    }
    ButtonControl {
        id: prevBtnId
        icon_default: 'images/prev.png'
        icon_pressed: 'images/hold-prev.png'
        height: mainBtnId.height / 2.25
        width: height*1.5
        anchors.verticalCenter: mainBtnId.verticalCenter
        anchors.right: mainBtnId.left
        Component.onCompleted: clicked.connect(utility.previous);
    }
    ButtonControl {
        id: nextBtnId
        icon_default: 'images/next.png'
        icon_pressed: 'images/hold-next.png'
        height: mainBtnId.height / 2.25
        width: height*1.5
        anchors.verticalCenter: mainBtnId.verticalCenter
        anchors.left: mainBtnId.right
        Component.onCompleted: clicked.connect(utility.next);
    }
    SwitchButton {
        id: shuffleBtnId
        status: utility.shuffle
        icon_on: 'images/shuffle-1.png'
        icon_off: 'images/shuffle.png'
        height: mainBtnId.height / 2.5
        width: height*2
        anchors.left: currentTimeId.left
        anchors.verticalCenter: mainBtnId.verticalCenter
        onClicked: utility.shuffle = !status
    }
    SwitchButton {
        id: repeatBtnId
        status: utility.repeat
        icon_on: 'images/repeat1_hold.png'
        icon_off: 'images/repeat.png'
        height: mainBtnId.height / 2.5
        width: height*2
        anchors.right: totalTimeId.right
        anchors.verticalCenter: mainBtnId.verticalCenter
        onClicked: utility.repeat = !status
    }
}
