import QtQuick 2.9

Item {
    property alias playlistBtnStatus: playlistBtnId.status
    signal clickedPlayListBtn
    Image {
        id: headerBgId
        source: "images/title.png"
        anchors.fill: parent
    }
    Text {
        id: headerTitleTxtId
        text: qsTr("STR_LABEL")
        color: "white"
        font.pixelSize: 100
        fontSizeMode: Text.VerticalFit
        anchors.centerIn: parent
        height: parent.height/2
        width: contentWidth
    }
    SwitchButton {
        id: playlistBtnId
        height: parent.height/3
        width: height
        anchors.left: parent.left
        anchors.leftMargin: width/2
        anchors.verticalCenter: parent.verticalCenter
        icon_off: 'images/back.png'
        icon_on: 'images/drawer.png'
        onClicked: {
            console.log("Playlist Button onClicked")
            clickedPlayListBtn()
        }
    }
    Text {
        text: qsTr("STR_PLAYLIST")
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: playlistBtnId.right
        anchors.leftMargin: playlistBtnId.width/3
        color: "white"
        font.pixelSize: headerTitleTxtId.fontInfo.pixelSize * 0.7
        MouseArea {
            anchors.fill: parent
            onClicked: playlistBtnId.clicked(mouse)
            cursorShape: Qt.PointingHandCursor
        }
    }

    Image {
        id: vnFlagId
        source: "images/vn.png"
        height: parent.height*0.4
        width: height
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: width/2
        Rectangle {
            color: "transparent"
            border.color: "goldenrod"
            border.width: parent.height/20
            width: parent.width + border.width
            height: width * 0.6
            anchors.centerIn: parent
            visible: Translator.language === "vn" ? true:false
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Translator.language = "vn"
        }
    }
    Image {
        id: usFlagId
        source: "images/us.png"
        height: parent.height*0.4
        width: height
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: vnFlagId.left
        anchors.rightMargin: width/2
        Rectangle {
            color: "transparent"
            border.color: "goldenrod"
            border.width: parent.height/20
            width: parent.width + border.width
            height: width * 0.6
            anchors.centerIn: parent
            visible: Translator.language === "us" ? true:false
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Translator.language = "us"
        }
    }
}
