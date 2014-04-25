import QtQuick 2.0

Rectangle {
    color: Qt.rgba(1,1,1,0.8);

    signal clicked;

    Text {
        id: noMoveText;
        anchors.centerIn: parent;
        text: "No moves available";
        font.pixelSize: 30;
    }
    Text {
        anchors.top: noMoveText.bottom;
        anchors.horizontalCenter: parent.horizontalCenter;
        text: "tap to restart"
    }

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            console.debug("lose clicked");
            parent.clicked();
        }
    }
}
