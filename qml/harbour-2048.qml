import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "pages";
import "cover";
import "storage.js" as Storage;

ApplicationWindow {
    id: app;
    cover: Component { CoverPage { } }
    initialPage: Component { MainPage { } }

    Component.onCompleted: {
        Storage.initialize();

        var size       = Storage.getLabel ("size");
        var difficulty = Storage.getLabel ("difficulty");
        var mode       = Storage.getLabel ("mode");

        if (size)       { app.size       = size; }
        if (difficulty) { app.difficulty = difficulty; }
        if (mode)       { app.mode       = mode; }

        var bestBestTile      = Storage.getLabel ("bestBestTile" + app.mode + app.difficulty + app.size);
        var bestClassicScore  = Storage.getLabel ("bestClassicScore" + app.mode + app.difficulty + app.size);
        var bestMoves         = Storage.getLabel ("bestMoves" + app.mode + app.difficulty + app.size);
        var bestImprovedScore = Storage.getLabel ("bestImprovedScore" + app.mode + app.difficulty + app.size);

        if (bestBestTile)      { app.bestBestTile      = bestBestTile; }
        if (bestClassicScore)  { app.bestClassicScore  = bestClassicScore; }
        if (bestMoves)         { app.bestMoves         = bestMoves; }
        if (bestImprovedScore) { app.bestImprovedScore = bestImprovedScore; }
    }

    Component.onDestruction: {
        game.save();
        Storage.setLabel ("size",       app.size);
        Storage.setLabel ("difficulty", app.difficulty);
        Storage.setLabel ("mode",       app.mode);
    }

    property int size           : 4;
    property string difficulty  : "Normal";
    property string mode        : "Classic";
    property int blizt          : 0;
    property Item game          : null;

    property int bestBestTile      : 2;
    property int bestClassicScore  : 0;
    property int bestMoves         : 0;
    property int bestImprovedScore : 0;

    property int currentMessage : 0;
    property var messages: [
        "Can you reach the 2048 tile?",
        "Alright, you got it, but seriously, wasn't it too simple? Say you reach the next one, 4096",
        "Wanna go easy? why not, but still, can you reach the 256 tile?",
        "Are you missing kindergarten? You have to reach the 16 tile",
        "Bravo!!! You're sooooo good",
        "No! Don't be silly, a one-sized board? I won't allow it, isn't 2 easy enough?",
        "NOT BAD!! To the next one! The four-sized board"
    ];
}


