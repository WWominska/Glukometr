TEMPLATE = app
TARGET = harbour-glukometr
QT += quick bluetooth sql
CONFIG += c++11
TRANSLATIONS += translations/harbour-glukometr-en.ts translations/harbour-glukometr-pl.ts


winrt {
    TEMPLATE += vcapp
    CONFIG += windeployqt
    WINRT_MANIFEST = winrt/AppxManifest.xml
    OTHER_FILES += winrt/*
}

unix:packagesExist(sailfishapp):!android {
    # Sailfish OS specific definitions
    RESOURCES += sailfish/resources.qrc
    SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256
    CONFIG += sailfishapp
    DEFINES += Q_OS_SAILFISH
    DISTFILES += harbour-glukometr.desktop \
                 sailfish/icons/* \
                 sailfish/rpm/*
} else {
    QT += quickcontrols2 widgets charts svg
    RESOURCES += android/resources.qrc
    OTHER_FILES += android/assets/*.qml \
               android/assets/pages/*.qml \
               android/assets/dialogs/*.qml \
               android/assets/components/*.qml
}

android {
    QTPLUGIN += QSQLITE

    OTHER_FILES += android/AndroidManifest.xml android/res/*

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

!isEmpty(target.path): INSTALLS += target


# Input
HEADERS += src/BleDiscovery.h \
           src/BleParser.h \
           src/Glucometer.h \
           src/database/SqlQueryModel.h \
           src/database/DatabaseWorker.h \
           src/database/Settings.h \
           src/database/MeasurementsListManager.h \
           src/database/BaseListManager.h \
           src/database/Thresholds.h \
           src/database/Drugs.h \
           src/database/MealAnnotations.h \
           src/database/TextAnnotations.h \
           src/database/DrugAnnotations.h \
           src/database/Reminders.h \
           src/database/Devices.h
SOURCES += src/BleDiscovery.cpp \
           src/main.cpp \
           src/BleParser.cpp \
           src/Glucometer.cpp \
           src/database/SqlQueryModel.cpp \
           src/database/DatabaseWorker.cpp \
           src/database/Settings.cpp \
           src/database/MeasurementsListManager.cpp \
           src/database/BaseListManager.cpp \
           src/database/Thresholds.cpp \
           src/database/Drugs.cpp \
           src/database/MealAnnotations.cpp \
           src/database/TextAnnotations.cpp \
           src/database/DrugAnnotations.cpp \
           src/database/Reminders.cpp \
           src/database/Devices.cpp

OTHER_FILES += common/assets/*.qml
