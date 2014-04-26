import QtQuick 2.0
import "helper.js" as Helper

Item {
    id: playground;

    property int size         : 3;
    property int bestTile     : 0;
    property var slots        : [];
    property var game         : undefined;
    property var tiles        : [];
    property int padding      : (width * 0.02);
    property var leftVectors  : Helper.getVectors("left");
    property var rightVectors : Helper.getVectors("right");
    property var upVectors    : Helper.getVectors("up");
    property var downVectors  : Helper.getVectors("down");

    signal justMoved;

    function addTiles (number) {
        var freeSpace = Helper.getFreeSpace(tiles, size);
        number = Math.min(number, freeSpace.length);
        for (var i = 0; i < number; i++) {
            var random = Math.floor(Math.random() * freeSpace.length);
            var index = freeSpace[random];
            if (tiles [index] === undefined) {
                tiles [index] = componentTile.createObject (slots [index], { "value" : 2 });
            }
            justMoved();
        }
    }

    function move(vectors) {
        var moved = Helper.dealWithVectors(vectors, tiles);
        if (moved) {
            addTiles(1);
        }
        else {
            var freeSpace = Helper.getFreeSpace(tiles, size);
            console.debug("freeSpace", freeSpace)
            if (freeSpace.length === 0) {
                console.debug("no space available");
                var mergeAvailable = Helper.mergeAvailable(leftVectors, tiles) || Helper.mergeAvailable(upVectors, tiles);
                if (!mergeAvailable) {
                    lose.visible = true;
                }
            }
        }
        justMoved();
    }

    function restartGame () {
        for (var i in tiles) {
            var tile = tiles[i];
            if (tile !== undefined) {
                tile.destroy();
                tiles[i] = undefined;
            }
        }
        bestTile = 2;
        addTiles(2);
    }

    Component {
        id: componentTile;

        Tile {
            onHasMerged: {
                if (value > bestTile) {
                    bestTile = value;
                }
                justMoved();
            }
        }
    }
    Rectangle {
        color: "white";
        opacity: 0.05;
        radius: width / 50;
        anchors.fill: parent;
    }
    SwipeArea {
        repeat: false;
        anchors.fill: parent;
        onMoveLeft:  { move (leftVectors);}
        onMoveRight: { move (rightVectors); }
        onMoveUp:    { move (upVectors);    }
        onMoveDown:  { move (downVectors);  }
    }
    Grid {
        id: backGrid;
        rows: tilesGrid.rows;
        columns: tilesGrid.columns;
        spacing: tilesGrid.spacing;
        anchors.fill: tilesGrid;

        Repeater {
            model: (size * size);
            delegate: Rectangle {
                color: "black";
                radius: (width * 0.05);
                width: tilesGrid.itemSize;
                height: tilesGrid.itemSize;
                opacity: 0.15;
            }
        }
    }
    Grid {
        id: tilesGrid;
        rows: size;
        columns: rows;
        spacing: padding;
        anchors {
            fill: parent;
            margins: padding;
        }
        Component.onCompleted: {
            //console.debug("left vectors :", leftVectors);
            //console.debug("right vectors :", rightVectors)
            //console.debug("up vectors :", upVectors)
            //console.debug("down vectors :", downVectors)
            if (game !== undefined) {
                for (var i in game) {
                    var value = parseInt (game [i]);
                    var slot = slots [i];
                    if (value > 0) {
                        tiles [i] = componentTile.createObject (slot, { "value" : value });
                        if (value > bestTile) {
                            bestTile = value;
                        }
                    }
                }
            }
            else {
                tiles [size * size - 1] = undefined;
                addTiles(2);
            }
        }

        property real itemSize : (((width + spacing) / columns) - spacing);

        Repeater {
            model: size * size;
            delegate: Rectangle {
                id: tileSlot;
                color: "transparent";
                radius: (width * 0.05);
                width: parent.itemSize;
                height: parent.itemSize;
                Component.onCompleted: { playground.slots [model.index] = tileSlot; }
            }
        }
    }
    Lose {
        id: lose;
        anchors.fill: parent;
        visible: false;
        onClicked: {
            visible = false;
            restartGame ();
        }
    }
}
