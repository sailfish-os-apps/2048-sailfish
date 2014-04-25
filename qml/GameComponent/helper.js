
function getVectors(direction) {
    var vectors = []
    for (var i = 0; i < size; i++) {
        var vector = []
        for (var j = 0; j < size; j++) {
            if (direction === "left") {
                vector[j] = i * size + j;
            }
            else if (direction === "right") {
                vector[j] = (i + 1) * size - j - 1;
            }
            else if (direction === "up") {
                vector[j] = j * size + i;
            }
            else if (direction === "down") {
                vector[j] = (size - j - 1) * size + i;
            }
        }
        vectors[i] = vector;
    }
    return vectors;
}

function dealWithVectors (vectors, tiles) {
    var moved = false;
    for (var i in vectors) {
        var vector = vectors[i];
        //console.debug("deal with vector :", vector)
        var newVector = [];
        for (var j = 0; j < vector.length; j++) {
            var index = vector[j];
            var tile = tiles[index];
            //console.debug("deal with index :", index, ", tile is", tile);
            if (tile !== undefined) {    // the tile exist and thus has a value
                newVector.push(index);
                newVector.push(tile);
            }
        }
        //console.debug("new vector :", newVector);
        var lastTile = undefined;
        var lastTileIndex = undefined;
        var merged = 0;
        for (var j = 1; j < newVector.length; j += 2) {
            var oldIndex = newVector[j - 1];
            var newIndex = vector[(j - 1) / 2 - merged];
            var tile = newVector[j];
            //console.debug("oldIndex :", oldIndex, ", newIndex :", newIndex)
            if (lastTile !== undefined && lastTile.value === tile.value) {
                //console.debug("merge", oldIndex);
                tiles[oldIndex] = undefined;
                tile.moveTo (slots[lastTileIndex], lastTile)
                moved = true;
                merged++;
                lastTile = undefined;
                lastTileIndex = undefined;
            }
            else {
                if (oldIndex !== newIndex) {
                    //console.debug("move", oldIndex, "to", newIndex);
                    tile.moveTo (slots[newIndex])
                    moved = true;
                    tiles[newIndex] = tile;
                    tiles[oldIndex] = undefined;
                }
                lastTile = tile;
                lastTileIndex = newIndex;
            }
        }
    }
    return moved;
}

function getFreeSpace (tiles, size) {
    var freeSpace = [];
    for (var i=0; i < size * size; i++) {
        var tile = tiles[i]
        if (tile === undefined) {
            freeSpace.push(i)
        }
    }
    return freeSpace;
}

function mergeAvailable(vectors, tiles) {
    for (var i in vectors) {
        var lastTileNumber = undefined;
        var vector = vectors[i];
        for (var j in vector) {
            var index = vector[j];
            var tile = tiles[index];
            if (lastTileNumber !== undefined && lastTileNumber === tile.value) {
                return true;
            }
            else {
                lastTileNumber = tile.value;
            }
        }
    }
    return false;
}
