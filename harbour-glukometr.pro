TEMPLATE = app
TARGET = harbour-glukometr
QT += quick bluetooth
CONFIG += c++11

winrt {
    TEMPLATE += vcapp
    CONFIG += windeployqt
    WINRT_MANIFEST = winrt/AppxManifest.xml
}

packagesExist(sailfishapp) {
    # Sailfish OS specific definitions
    RESOURCES += sailfish/resources.qrc
    SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256
    CONFIG += sailfishapp
    DEFINES += Q_OS_SAILFISH

    DISTFILES += sailfish/harbour-glukometr.desktop \
        rpm/harbour-glukometr.changes \
        rpm/harbour-glukometr.changes.run.in \
        rpm/harbour-glukometr.yaml
} else {
    RESOURCES += common/resources.qrc
}

android {
    DISTFILES += \
        android/AndroidManifest.xml \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradlew \
        android/res/values/libs.xml \
        android/build.gradle \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew.bat

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}


# Input
HEADERS += urzadzenie.h \
           glukometr.h \
    historia.h
SOURCES += urzadzenie.cpp \
           glukometr.cpp \
           main.cpp

OTHER_FILES += python/* \
               common/* \
               common/assets/*.qml \
               sailfish/* \
               sailfish/rpm/* \
               sailfish/assets/*.qml \
               android/AndroidManifest.xml android/res/* \
               winrt/*
