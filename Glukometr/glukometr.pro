TEMPLATE = app vcapp
TARGET = glukometr

QT += quick bluetooth
CONFIG += windeployqt

CONFIG += c++11

#WINRT_MANIFEST = AppxManifest.xml

# Input
HEADERS += urzadzenie.h \
           glukometr.h \
    historia.h
SOURCES += urzadzenie.cpp \
           glukometr.cpp \
           main.cpp

OTHER_FILES += assets/*.qml \
               assets/*.js

RESOURCES += \
             resources.qrc

target.path = $$[QT_INSTALL_EXAMPLES]/bluetooth/glukometr
INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
