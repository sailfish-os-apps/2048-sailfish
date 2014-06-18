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
        var size = Storage.getLabel ("size");
        if (size) {
            app.size = size;
        }
        var bestEver = Storage.getLabel ("best" + app.size);
        if (bestEver) {
            app.bestEver = bestEver;
        }
    }

    Component.onDestruction: {
        game.save();
    }

    property int size: 4;
    property Item game : null;
    property int bestEver: 2;
    property int highscore: 0;
    property int currentMessage: 0;
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


