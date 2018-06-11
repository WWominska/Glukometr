import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

ApplicationWindow {
    id: application
    property bool isTutorialEnabled: false
    property bool measurementPageOpen: false
    property bool bluetoothPageOpen: false

    cover: Qt.resolvedUrl("qrc:/assets/cover/CoverPage.qml")
    initialPage: Component { Results {} }
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted:
    {
        if (settings.isFirstRun)
        {
            settings.isFirstRun = false
            pageStack.push(Qt.resolvedUrl("Tutorial.qml"), {}, PageStackAction.Immediate)
        }
    }

    GlucoseApplication {
        id: pythonGlukometr
    }

    ConfigurationGroup {
        id: settings
        path: "/apps/harbour-glukometr"
        property bool isFirstRun: true
        property string phoneNumber: ""
    }
}
