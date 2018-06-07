import QtQuick 2.0
import Sailfish.Silica 1.0

ApplicationWindow {
    id: application
    property bool measurementPageOpen: false
    property bool bluetoothPageOpen: false

    cover: Qt.resolvedUrl("qrc:/assets/cover/CoverPage.qml")
    initialPage: Component { Results {} }
    allowedOrientations: defaultAllowedOrientations

    GlucoseApplication {
        id: pythonGlukometr
    }
}
