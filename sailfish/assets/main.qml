import QtQuick 2.0
import Sailfish.Silica 1.0

ApplicationWindow {
    id: application
    property bool isTutorialEnabled: false

    cover: Qt.resolvedUrl("qrc:/assets/cover/CoverPage.qml")
    initialPage: Component { Results {} }
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: pageStack.push(Qt.resolvedUrl("Tutorial.qml"), {}, PageStackAction.Immediate)

    GlucoseApplication {
        id: pythonGlukometr
    }
}
