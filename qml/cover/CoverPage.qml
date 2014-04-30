import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Column {
        spacing: Theme.paddingSmall;
        anchors {
            fill: parent;
            margins: Theme.paddingLarge;
        }

        Column {
            anchors {
                left: parent.left;
                right: parent.right;
            }

            Label {
                text: "Size";
                color: Theme.primaryColor;
                height: contentHeight;
                font.pixelSize: Theme.fontSizeMedium;
                horizontalAlignment: Text.AlignHCenter;
                anchors {
                    left: parent.left;
                    right: parent.right;
                }
            }
            Label {
                text: app.size;
                color: Theme.highlightColor;
                height: contentHeight;
                font.pixelSize: Theme.fontSizeLarge;
                horizontalAlignment: Text.AlignHCenter;
                anchors {
                    left: parent.left;
                    right: parent.right;
                }
            }
        }
        Column {
            anchors {
                left: parent.left;
                right: parent.right;
            }

            Label {
                text: "Current best tile";
                color: Theme.primaryColor;
                height: contentHeight;
                font.pixelSize: Theme.fontSizeMedium;
                horizontalAlignment: Text.AlignHCenter;
                anchors {
                    left: parent.left;
                    right: parent.right;
                }
            }
            Label {
                text: app.playground.bestTile;
                color: Theme.highlightColor;
                height: contentHeight;
                font.pixelSize: Theme.fontSizeLarge;
                horizontalAlignment: Text.AlignHCenter;
                anchors {
                    left: parent.left;
                    right: parent.right;
                }
            }
        }
        Column {
            anchors {
                left: parent.left;
                right: parent.right;
            }

            Label {
                text: "Best tile ever";
                color: Theme.primaryColor;
                height: contentHeight;
                font.pixelSize: Theme.fontSizeMedium;
                horizontalAlignment: Text.AlignHCenter;
                anchors {
                    left: parent.left;
                    right: parent.right;
                }
            }
            Label {
                text: app.bestEver;
                color: Theme.highlightColor;
                height: contentHeight;
                font.pixelSize: Theme.fontSizeLarge;
                horizontalAlignment: Text.AlignHCenter;
                anchors {
                    left: parent.left;
                    right: parent.right;
                }
            }
        }
    }
    CoverActionList {
        CoverAction {
            iconSource: "image://theme/icon-l-left";
            onTriggered: {
                if (app.size > 2) {
                    app.size--;
                }
            }
        }
        CoverAction {
            iconSource: "image://theme/icon-l-right";
            onTriggered: {
                if (app.size < 10) {
                    app.size++;
                }
            }
        }
    }
}
