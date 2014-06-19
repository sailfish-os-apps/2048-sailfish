# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-2048

CONFIG += sailfishapp

SOURCES += src/harbour-2048.cpp

OTHER_FILES += qml/harbour-2048.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-2048.changes.in \
    rpm/harbour-2048.spec \
    rpm/harbour-2048.yaml \
    harbour-2048.desktop \
    qml/pages/MainPage.qml \
    qml/storage.js \
    qml/SailTileDesign.qml \
    qml/pages/ChangeMode.qml \
    qml/ScoreItem.qml \
    qml/Setting.qml

# to disable building translations every time, comment out the
# following CONFIG line
#CONFIG += sailfishapp_i18n
#TRANSLATIONS += translations/harbour-2048-de.ts

