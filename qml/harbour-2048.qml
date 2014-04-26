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
import "pages"
import "../qml/storage.js" as Storage

ApplicationWindow
{
    id: app;
    initialPage: MainPage {id: mainPage }
    cover: Qt.resolvedUrl("cover/CoverPage.qml");

    property int size: 4;
    property Item playground;
    property int bestEver: 2;
    property int currentMessage: 0;

    onSizeChanged: {
        if (size < 2) {
            currentMessage = 5;
            size++;
        }
        if (size === 2 && currentMessage !== 5) {
            currentMessage = 3;
        }
        if (size === 3) {
            currentMessage = 2;
        }
        if (size === 4) {
            currentMessage = 0;
        }

        mainPage.loadPlayground();
    }

    Component.onCompleted: {
        Storage.initialize();
        var size = Storage.getLabel("size");
        if (size) {
            app.size = size;
        }
        var bestEver = Storage.getLabel("best" + app.size);
        if (bestEver) {
            app.bestEver = bestEver;
        }
    }

    property var messages: [
        "Can you get the 2048 tile ?",
        "Alright, you got it, but seriously, wasn't it too easy ? What about you try to get the next one, the 4096 tile",
        "Wanna go easy ? why not, but still, can you get the 256 tile ?",
        "Are you mising kinder garden ? You have to get the 16 tile",
        "I won't congratulate you, that was way too easy. Try a bigger board",
        "No ! Let's stay serious, a one-sized board ? I won't allow it, isn't 2 easy enough ?",
        "NOT BAD !! To the next one ! The four-sized board"
    ]

}


