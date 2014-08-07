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

    property int size           : 4;
    property string difficulty  : "Normal";
    property string mode        : "Classic";
    property string tileFormat  : "TetraTile"
    property int blizt          : 0;
    property Item game          : null;
    property int bestEver       : 2;
    property int highscore      : 0;
}


