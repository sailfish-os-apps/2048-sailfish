import QtQuick 2.0

Rectangle {
    width: 360
    height: 360
    GamePlayground{
        anchors.centerIn: parent;
        width: Math.min(parent.width, parent.height);
        height: Math.min(parent.width, parent.height);
        //game: [16384,8192,4096,2048,1024,512,256,128,64,32,16,8,4,2];
        size: 2;
    }
}

