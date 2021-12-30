import QtQuick 2.9

MouseArea {
    property string icon_default: ""
    property string icon_pressed: ""
    property string icon_released: icon_default
    property alias source: imgId.source
    cursorShape: Qt.PointingHandCursor
    implicitWidth: imgId.width
    implicitHeight: imgId.height
    Image {
        id: imgId
        source: icon_default
        height: parent.height
        width: parent.width
        anchors.centerIn: parent
    }

    onPressed: {
        imgId.source = icon_pressed
    }
    onReleased: {
        imgId.source = icon_released
    }
}
