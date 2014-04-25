import QtQuick 2.0
import "helper.js" as Helper

Rectangle {
    id: playground;
    color: Qt.rgba(1,1,1,0.2);
    radius: width / 50;
    border.width: padding;
    border.color: Qt.rgba(1,1,1,0.2);
    focus: true;

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
    readonly property var colors : {
        var tmp = {};
        var max = size * size;
        for (var idx = 1; idx < max; idx++) {
            tmp [Math.pow (2, idx)] = Qt.hsla (idx / max, 0.85, 0.65, 0.6);
        }
        //console.log (JSON.stringify (tmp));
        return tmp;
    }
    signal justMoved;

    function addTiles (number) {
        var freeSpace = Helper.getFreeSpace(tiles, size);
        number = Math.min(number, freeSpace.length);
        for (var i = 0; i < number; i++) {
            var random = Math.floor(Math.random() * freeSpace.length);
            var index = freeSpace[random];
            if (tiles [index] === undefined) {
                tiles [index] = componentTile.createObject (slots [index], { "value" : 2, "colors": colors });
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
                color: Qt.rgba(0,0,0,0.2);
                radius: (width * 0.05);
                width: tilesGrid.itemSize;
                height: tilesGrid.itemSize;
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

        property real itemSize : (((width + spacing) / columns) - spacing);

        Repeater {
            model: size * size;
            Rectangle {
                id: tileSlot;
                color: "transparent";
                radius: (width * 0.05);
                width: parent.itemSize;
                height: parent.itemSize;
                Component.onCompleted: { playground.slots [model.index] = tileSlot; }
            }
        }

        Component.onCompleted: {
            //console.debug("left vectors :", leftVectors);
            //console.debug("right vectors :", rightVectors)
            //console.debug("up vectors :", upVectors)
            //console.debug("down vectors :", downVectors)
            if (game !== undefined) {
                for (var i in game) {
                    var value = game[i];
                    var slot = slots[i];
                    if (value != 0) {
                        tiles [i] = componentTile.createObject (slot, { "value" : value, "colors": colors });
                        if (value > bestTile) {
                            bestTile = value;
                        }
                    }
                }
            }
            else {
                tiles[size * size - 1] = undefined;
                addTiles(2);
            }
        }
    }


    Lose {
        id: lose;
        anchors.fill: parent;
        visible: false;

        onClicked: {
            visible = false;
            restartGame();
        }
    }
}
