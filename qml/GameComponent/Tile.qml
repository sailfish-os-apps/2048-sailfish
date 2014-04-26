import QtQuick 2.0;
import Sailfish.Silica 1.0;

Item {
    id: tile;
    width: parent.width;
    height: parent.height;
    scale: 0.65;
    Component.onCompleted: PropertyAnimation {
        target: tile;
        property: "scale";
        to: 1.0;
        duration: 250;
    }

    property int value: 0;

    signal hasMerged ();

    function upgrade () {
        value *= 2;
        hasMerged ();
    }
    function moveTo (newParent, mergeWith) { // call this and pass another Tile item as param
        if (newParent) {
            component.createObject (newParent, {
                                        "newParent" : newParent,
                                        "mergeWith" : (mergeWith || null)
                                    });
        }
    }

    Rectangle {
        radius: tile.parent.radius;
        color: Theme.secondaryHighlightColor;
        opacity: 0.45;
        anchors.fill: parent;
    }
    Label {
        text: value;
        color: Theme.primaryColor;
        verticalAlignment: Text.AlignVCenter;
        horizontalAlignment: Text.AlignHCenter;
        fontSizeMode: Text.Fit;
        minimumPixelSize: Theme.fontSizeTiny;
        font {
            bold: true;
            family: Theme.fontFamilyHeading;
            pixelSize: Theme.fontSizeHuge;
        }
        anchors {
            fill: parent;
            margins: Theme.paddingSmall;
        }
    }
    Component {
        id: component;

        SequentialAnimation {
            id: anim;
            loops: 1;
            running: false;
            alwaysRunToEnd: true;
            onStopped: { anim.destroy (); }
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
                        anim.mergeWith.upgrade ();
                        tile.destroy ();
                    }
                }
            }
            PropertyAnimation {
                target: anim.mergeWith;
                property: "scale";
                to: 1.25;
                duration: 150;
            }
            PropertyAnimation {
                target: anim.mergeWith;
                property: "scale";
                to: 1.0;
                duration: 150;
            }
        }
    }
}
