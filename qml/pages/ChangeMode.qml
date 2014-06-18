import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../storage.js" as Storage;

Page {
    id: page;

    Column {
        spacing: 10;
        anchors.fill: parent;

        PageHeader {
            title: "Change Mode"
        }

        BackgroundItem {
            id: difficulty;
            width: parent.width
            height: menuDifficulty.visible ? menuDifficulty.height + labelDifficulty.height : labelDifficulty.height

            Label {
                id: labelDifficulty;
                text: "Difficulty : " + app.difficulty;
                color: Theme.primaryColor;
                antialiasing: true;
                fontSizeMode: Text.Fit;
                minimumPixelSize: Theme.fontSizeTiny;
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge;
                ContextMenu {
                    id: menuDifficulty;
                    MenuItem {
                        text: "Easy"
                        onClicked: app.difficulty = "Easy";
                    }
                    MenuItem {
                        text: "Normal"
                        onClicked: app.difficulty = "Normal";
                    }
                    MenuItem {
                        text: "Hard"
                        onClicked: app.difficulty = "Hard";
                    }
                }
            }
            onPressAndHold: menuDifficulty.show(difficulty);
        }

        BackgroundItem {
            id: gameMode;
            width: parent.width
            height: menuMode.visible ? menuMode.height + labelMode.height : labelMode.height

            Label {
                id: labelMode;
                text: "Mode : " + app.mode;
                color: Theme.primaryColor;
                antialiasing: true;
                fontSizeMode: Text.Fit;
                minimumPixelSize: Theme.fontSizeTiny;
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge;
                ContextMenu {
                    id: menuMode;
                    MenuItem {
                        text: "Classic"
                        onClicked: app.mode = "Classic";
                    }
                }
            }
            onPressAndHold: menuMode.show(gameMode);
        }

        BackgroundItem {
            id: size;
            width: parent.width
            height: menuSize.visible ? menuSize.height + labelSize.height : labelSize.height

            Label {
                id: labelSize;
                text: "Size : " + app.size;
                color: Theme.primaryColor;
                antialiasing: true;
                fontSizeMode: Text.Fit;
                minimumPixelSize: Theme.fontSizeTiny;
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge;
                ContextMenu {
                    id: menuSize;
                    MenuItem {
                        text: "2"
                        onClicked: app.size = 2;
                    }
                    MenuItem {
                        text: "3"
                        onClicked: app.size = 3;
                    }
                    MenuItem {
                        text: "4"
                        onClicked: app.size = 4;
                    }
                    MenuItem {
                        text: "5"
                        onClicked: app.size = 5;
                    }
                    MenuItem {
                        text: "6"
                        onClicked: app.size = 6;
                    }
                }
            }
            onPressAndHold: menuSize.show(size);
        }
    }
}
