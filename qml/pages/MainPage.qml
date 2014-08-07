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

        var bestBestTile      = Storage.getLabel ("bestBestTile" +      app.mode + app.tileFormat + app.difficulty + app.size);
        var bestClassicScore  = Storage.getLabel ("bestClassicScore" +  app.mode + app.tileFormat + app.difficulty + app.size);
        var bestMoves         = Storage.getLabel ("bestMoves" +         app.mode + app.tileFormat + app.difficulty + app.size);
        var bestImprovedScore = Storage.getLabel ("bestImprovedScore" + app.mode + app.tileFormat + app.difficulty + app.size);

        if (bestBestTile)      { app.bestBestTile      = bestBestTile; }
        if (bestClassicScore)  { app.bestClassicScore  = bestClassicScore; }
        if (bestMoves)         { app.bestMoves         = bestMoves; }
        if (bestImprovedScore) { app.bestImprovedScore = bestImprovedScore; }

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
                    value: app.bestBestTile;
                }
            }
            Label {
                text: ""
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
                if (bestTile > app.bestBestTile) {
                    app.bestBestTile = bestTile;
                }
            }
            onSave: {
                Storage.setLabel ("bestBestTile" +      app.mode + app.tileFormat + app.difficulty + app.size, app.bestBestTile);
                Storage.setLabel ("bestClassicScore" +  app.mode + app.tileFormat + app.difficulty + app.size, app.bestClassicScore);
                Storage.setLabel ("bestMoves" +         app.mode + app.tileFormat + app.difficulty + app.size, app.bestMoves);
                Storage.setLabel ("bestImprovedScore" + app.mode + app.tileFormat + app.difficulty + app.size, app.bestImprovedScore);

                Storage.setLabel (app.mode + app.tileFormat + app.difficulty + app.size, initState.join (","));
            }
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
                if (bestTile > app.bestBestTile) {
                    app.bestBestTile = bestTile;
                }
            }
            onSave: {
                Storage.setLabel ("bestBestTile" +      app.mode + app.tileFormat + app.difficulty + app.size, app.bestBestTile);
                Storage.setLabel ("bestClassicScore" +  app.mode + app.tileFormat + app.difficulty + app.size, app.bestClassicScore);
                Storage.setLabel ("bestMoves" +         app.mode + app.tileFormat + app.difficulty + app.size, app.bestMoves);
                Storage.setLabel ("bestImprovedScore" + app.mode + app.tileFormat + app.difficulty + app.size, app.bestImprovedScore);

                Storage.setLabel (app.mode + app.tileFormat + app.difficulty + app.size, initState.join (","));
            }
        }
    }
}
