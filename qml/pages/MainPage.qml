import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../GameComponent";
import "../storage.js" as Storage;

Page {
    id: page;

    function loadPlayground () {
        Storage.initialize();
        if (app.playground) {
            app.playground.destroy ();
        }
        var gameValues = Storage.getLabel (app.size);
        if (gameValues) {
            var t = "";
            var game = gameValues.split (",");
            console.debug (game);
            app.playground = playgroundComponent.createObject (gameContainer, { "size" : app.size, "game": game });
        }
        else {
            app.playground = playgroundComponent.createObject (gameContainer, { "size" : app.size });
        }
        var score = Storage.getLabel ("score" + app.size);
        if(score)
        {
            app.playground.score = score;
        }
        var highscore = Storage.getLabel ("highscore" + app.size);
        if(!highscore)
        {
            highscore = 0;
        }

        app.highscore = highscore;

        dealWithMessage ();
    }

    function dealWithMessage () {
        if (size === 2 && currentMessage !== 5) {
            currentMessage = 3;
        }
        if (size === 3) {
            currentMessage = 2;
        }
        if (size === 4) {
            currentMessage = 0;
        }
        if (app.size === 2 && app.playground && app.playground.bestTile >= 16){
            app.currentMessage = 4;
        }
        if (app.size === 3 && app.playground && app.playground.bestTile >= 256) {
            app.currentMessage = 6;
        }
        if (app.size === 4 && app.playground && app.playground.bestTile >= 2048) {
            app.currentMessage = 1;
        }
    }

    Connections {
        target: app;
        onSizeChanged: { loadPlayground (); }
    }
    SilicaFlickable {
        id: control;
        contentHeight: column.height;
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
            bottom: gameContainer.top;
        }

        PullDownMenu {
            MenuItem {
                text: "Restart game";
                font.family: Theme.fontFamilyHeading;
                onClicked: playground.restartGame ();
            }
        }
        Column {
            id: column;
            spacing: Theme.paddingMedium;
            anchors {
                left: parent.left;
                right: parent.right;
                margins: Theme.paddingLarge;
            }

            PageHeader {
                title: (playground ? "Best Tile : %1".arg (playground.bestTile) : "....");
            }

            Row {
                spacing: Theme.paddingMedium;
                anchors.horizontalCenter: parent.horizontalCenter;

                width: parent.width*.6;
                height: 80;
                ScoreItem {
                    label: "SCORE";
                    value: app.playground.score;
                }
                ScoreItem {
                    label: "BEST";
                    value: app.highscore;
                }

            }
            Row {
                spacing: Theme.paddingMedium;
                anchors.horizontalCenter: parent.horizontalCenter;

                IconButton {
                    icon.source: "image://theme/icon-l-left";
                    enabled: (app.size > 2);
                    onClicked: {
                        playground.save();
                        app.size--;
                    }
                }
                Label {
                    text: "Size : %1".arg (app.size);
                    color: Theme.highlightColor;
                    font.family: Theme.fontFamilyHeading;
                    anchors.verticalCenter: parent.verticalCenter;
                }
                IconButton {
                    icon.source: "image://theme/icon-l-right";
                    enabled: (app.size < 10);
                    onClicked: {
                        playground.save();
                        app.size++;
                    }
                }
            }
            Label {
                color: Theme.highlightColor
                font.family: Theme.fontFamilyHeading
                text: "Best tile ever : %1".arg (app.bestEver);
                anchors {
                    left: parent.left;
                    right: parent.right;
                }
            }
            Label {
                text: (app.messages [app.currentMessage] || "");
                color: Theme.primaryColor
                font.family: Theme.fontFamilyHeading;
                font.pixelSize: Theme.fontSizeSmall;
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere;
                anchors {
                    left: parent.left;
                    right: parent.right;
                }
            }
        }
    }
    Item {
        id: gameContainer;
        height: width;
        anchors {
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }
        Component.onCompleted: { loadPlayground (); }
    }
    Component {
        id: playgroundComponent;

        GamePlayground {
            anchors {
                fill: parent;
                margins: Theme.paddingLarge;
            }
            onJustMoved: {
                var highscore = Storage.getLabel ("highscore" + app.size);
                if(!highscore || highscore < playground.score)
                {
                    highscore = playground.score;
                }
                app.highscore = highscore;
            }
            onBestTileChanged: {
                var bestEver = Storage.getLabel ("best" + app.size);
                console.debug (bestEver);
                if (bestEver) {
                    app.bestEver = bestEver;
                }
                if (!bestEver || bestTile > bestEver) {
                    Storage.setLabel ("best" + app.size, bestTile);
                    app.bestEver = bestTile;
                }
                dealWithMessage();
            }
        }
    }
}
