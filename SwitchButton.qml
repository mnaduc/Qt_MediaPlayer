import QtQuick 2.9

MouseArea {
    property string icon_on: ""
    property string icon_off: ""
    property bool status: false
    cursorShape: Qt.PointingHandCursor
    implicitWidth: imgId.width
    implicitHeight: imgId.height
    Image {
        id: imgId
        source: parent.status ? icon_on : icon_off
        anchors.centerIn: parent
        height: parent.height
        width: parent.width
    }
}
