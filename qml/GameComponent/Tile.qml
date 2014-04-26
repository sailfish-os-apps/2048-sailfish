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
        color: Theme.highlightColor;
        radius: tile.parent.radius;
        opacity: {
            switch (value) {
            case 0:    return 0.00;
            case 2:    return 0.15;
            case 4:    return 0.20;
            case 8:    return 0.25;
            case 16:   return 0.30;
            case 32:   return 0.35;
            case 64:   return 0.40;
            case 128:  return 0.45;
            case 256:  return 0.50;
            case 512:  return 0.55;
            case 1024: return 0.65;
            case 2048: return 0.70;
            case 4096: return 0.85;
            case 8192: return 0.90;
            default:   return 1.00;
            }
        }
        anchors.fill: parent;
    }
    Label {
        text: value;
        color: Theme.primaryColor;
        style: Text.Outline;
        styleColor: "black";
        antialiasing: true;
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
