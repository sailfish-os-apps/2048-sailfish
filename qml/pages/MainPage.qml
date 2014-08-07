import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../Game";
import "..";
import "../storage.js" as Storage;

Page {
    id: page;

    function loadGame () {
        Storage.initialize();
        if (app.game) {
            app.game.destroy ();
        }
        var gameValues = Storage.getLabel (app.mode + app.tileFormat + app.difficulty + app.size);
        if (gameValues) {
            var t = "";
            var game = gameValues.split (",");
            console.debug (game);
            if (app.tileFormat === "HexaTile") {
                app.game = hexaGameComponent.createObject (gameContainer, { "size" : app.size, "initState": game });
            }
            else {
                app.game = gameComponent.createObject (gameContainer, { "size" : app.size, "initState": game });
            }
        }
        else {
            if (app.tileFormat === "HexaTile") {
                app.game = hexaGameComponent.createObject (gameContainer, { "size" : app.size });
            }
            else {
                app.game = gameComponent.createObject (gameContainer, { "size" : app.size });
            }
        }
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
        if (app.size === 2 && app.game && app.game.bestTile >= 16){
            app.currentMessage = 4;
        }
        if (app.size === 3 && app.game && app.game.bestTile >= 256) {
            app.currentMessage = 6;
        }
        if (app.size === 4 && app.game && app.game.bestTile >= 2048) {
            app.currentMessage = 1;
        }
    }

    Connections {
        target: app;
        onSizeChanged       : { loadGame (); }
        onDifficultyChanged : { loadGame (); }
        onModeChanged       : { loadGame (); }
        onTileFormatChanged : { loadGame (); }
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
                text: "Change Mode";
                font.family: Theme.fontFamilyHeading;
                onClicked: pageStack.push("ChangeMode.qml");
            }
            MenuItem {
                text: "Restart game";
                font.family: Theme.fontFamilyHeading;
                onClicked: app.game.restart();
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
                title: "Mode : " + app.mode + " " + app.difficulty + " " + app.size;
            }
            Row {
                spacing: Theme.paddingMedium;
                anchors.horizontalCenter: parent.horizontalCenter;

                width: parent.width*.6;
                height: 80;
                ScoreItem {
                    label: "TILE";
                    value: app.game.bestTile;
                }
                ScoreItem {
                    label: "BEST";
                    value: app.bestEver;
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
        Component.onCompleted: { loadGame (); }
    }
    Component {
        id: gameComponent;

        Game {
            design: Component { SailTileDesign {} }
            mode: modes[app.mode + app.difficulty]
            anchors {
                fill: parent;
                margins: Theme.paddingLarge;
            }
            onBestTileChanged: {
                var bestEver = Storage.getLabel ("best" + app.mode + app.tileFormat + app.difficulty + app.size);
                console.debug (bestEver);
                if (bestEver) {
                    app.bestEver = bestEver;
                }
                if (!bestEver || bestTile > bestEver) {
                    Storage.setLabel ("best" + app.mode + app.tileFormat + app.difficulty + app.size, bestTile);
                    app.bestEver = bestTile;
                }
                dealWithMessage();
            }
            onSave: { Storage.setLabel (app.mode + app.tileFormat + app.difficulty + app.size, initState.join (",")); }
        }
    }
    Component {
        id: hexaGameComponent;

        HexaGame {
            design: Component { SailHexaDesign {} }
            mode: modes[app.mode + app.difficulty]
            anchors {
                fill: parent;
                margins: Theme.paddingLarge;
            }
            onBestTileChanged: {
                var bestEver = Storage.getLabel ("best" + app.size);
                console.debug (bestEver);
                if (bestEver) {
                    app.bestEver = bestEver;
                }
                if (!bestEver || bestTile > bestEver) {
                    Storage.setLabel ("best" + app.mode + app.tileFormat + app.difficulty + app.size, bestTile);
                    app.bestEver = bestTile;
                }
                dealWithMessage();
            }
            onSave: { Storage.setLabel (app.mode + app.tileFormat + app.difficulty + app.size, initState.join (",")); }
        }
    }
}
