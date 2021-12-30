QT += quick core multimedia

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000

SOURCES += \
    main.cpp \
    player.cpp \
    playlistmodel.cpp \
    translator.cpp

RESOURCES += \
    qml.qrc \
    resource.qrc

INCLUDEPATH += MyTagLib/include

# Default rules for deployment.
win32 {
    LIBS += -L$$PWD/MyTagLib/windows -lMyTagLib
}

linux {
    LIBS += -L$$PWD/MyTagLib/ubuntu -lMyTagLib
}

qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

TRANSLATIONS += \
    translator/translate_vn.ts \
    translator/translate_us.ts

HEADERS += \
    player.h \
    playlistmodel.h \
    translator.h
