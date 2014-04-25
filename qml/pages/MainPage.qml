/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../GameComponent"
import "../../qml/storage.js" as Storage


Page {
    id: page

    function loadPlayground () {
        if (app.playground) {
            app.playground.destroy();
        }
        var gameValues = Storage.getLabel(app.size);
        if (gameValues) {
            var t = "";
            var game = gameValues.split(",");
            console.debug(game);
            app.playground = playgroundComponent.createObject (gameContainer, { "size" : app.size, "game": game});
        }
        else {
            app.playground = playgroundComponent.createObject (gameContainer, { "size" : app.size});
        }

    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        id: control;
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height / 3;

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: "Restart game"
                onClicked: playground.restartGame();
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: playground ? "Best Tile : " + playground.bestTile : "....";
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter;
                spacing: 20;

                IconButton {
                   icon.source: "image://theme/icon-l-left"
                   onClicked: {app.size--;loadPlayground();}
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter;
                    color: Theme.highlightColor
                    font.family: Theme.fontFamilyHeading
                    text: "Size : " + app.size;
                }
                IconButton {
                    icon.source: "image://theme/icon-l-right"
                   onClicked: {app.size++;loadPlayground();}
                }
            }
            Label {
                color: Theme.highlightColor
                font.family: Theme.fontFamilyHeading
                text: "Best tile ever : " + app.bestEver;
            }
        }
    }
    SilicaFlickable {
        id: gameContainer;
        height: width;
        anchors {
            bottom: parent.bottom;
            left: parent.left;
            right: parent.right;
        }
        Component.onCompleted: {
            loadPlayground();
        }
    }
    Component {
        id: playgroundComponent;
        GamePlayground {
            anchors.centerIn: parent;

            property int padding: 30;

            width: Math.min(parent.width - padding, parent.height - padding);
            height: width;

            onJustMoved: {
                var game = [];
                for (var i = 0; i < tiles.length; i++) {
                    var tile = tiles[i];
                    if (tile !== undefined) {
                        game.push(tile.value);
                    }
                    else {
                        game.push(0);
                    }
                }
                console.debug("tiles", tiles);
                console.debug(game, game.join(","));
                Storage.setLabel(app.size, game.join(","));
            }
            onBestTileChanged: {
                var bestEver = Storage.getLabel("best" + app.size);
                console.debug(bestEver);
                if (bestEver) {
                    app.bestEver = bestEver;
                }
                if (!bestEver || bestTile > bestEver) {
                    Storage.setLabel("best" + app.size, bestTile);
                    app.bestEver = bestTile;
                }

            }
        }
    }
}


