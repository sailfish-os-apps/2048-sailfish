import QtQuick 2.0

Rectangle {
    id: tile;
    width: parent.width;
    height: parent.height;
    scale: 0.7;
    anchors.centerIn: parent;
    radius: parent.radius;
    color: (colors [value] || "magenta");
    z:1000 + parent.z;


    property Item newParent;
    property Item mergedWith;
    property int value: 0;
    property var colors;

    signal hasMerged;

    Text {
        anchors.centerIn: parent;
        text: value;
        font.pixelSize: 30;
    }

    Behavior on scale {
        SequentialAnimation {
            PropertyAnimation { duration: 100 }
            ScriptAction {script: {anchors.centerIn = undefined}}
            PropertyAnimation { to:1.0; duration: 100 }
        }
    }

    function upgrade() {
        value *= 2;
        hasMerged();
        //console.debug("bump", value);
        tile.scale = 1.2;
    }

    Component.onCompleted: {
        scale = 1;
    }

    function moveTo (newParent, mergeWith) { // call this and pass another Tile item as param
        if (newParent) {
            component.createObject (newParent, {
                                        "newParent" : newParent,
                                        "mergeWith" : (mergeWith || null)
                                    });
        }
    }

    Component {
        id: component;

        SequentialAnimation {
            id: anim;
            loops: 1;
            running: false;
            alwaysRunToEnd: true;
            onStopped: {
                if (mergeWith) {
                    tile.destroy ();
                }
            }
            Component.onCompleted: {
                var tmp = anim.newParent.mapFromItem (tile, tile.x, tile.y);
                //console.debug ("tmp", JSON.stringify (tmp));
                tile.parent = anim.newParent;
                tile.x = tmp ['x'];
                tile.y = tmp ['y'];
                start ();
            }

            property Item newParent : null;
            property Item mergeWith : null;

            ParallelAnimation {
                PropertyAnimation {
                    target: tile;
                    property: "x";
                    to: 0;
                    duration: 100;
                }
                PropertyAnimation {
                    target: tile;
                    property: "y";
                    to: 0;
                    duration: 100;
                }
            }
            ScriptAction {
                script: {
                    if (anim.mergeWith) {
                        console.debug ("merge", tile,"(", value, ")" ,"with", anim.mergeWith);
                        anim.mergeWith.upgrade();
                    }
                }
            }
        }
    }
}
