TEMPLATE = app vcapp
TARGET = harbour-glukometr

QT += quick bluetooth
CONFIG += windeployqt

CONFIG += c++11
CONFIG += link_pkgconfig sailfishapp

#WINRT_MANIFEST = AppxManifest.xml

# Input
HEADERS += urzadzenie.h \
           glukometr.h \
    historia.h
SOURCES += urzadzenie.cpp \
           glukometr.cpp \
           main.cpp

OTHER_FILES += assets/*.qml \
               assets/*.js harbour-glukometr.desktop rpm/*

RESOURCES += \
             resources.qrc

target.path = $$[QT_INSTALL_EXAMPLES]/bluetooth/glukometr
INSTALLS += target

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

DISTFILES += harbour-glukometr.desktop \
    rpm/harbour-glukometr.changes \
    rpm/harbour-glukometr.changes.run.in \
    rpm/harbour-glukometr.yaml

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
