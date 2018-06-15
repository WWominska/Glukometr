import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "pages";

ApplicationWindow {
    id: application
    property bool isTutorialEnabled: false
    property bool measurementPageOpen: false
    property bool bluetoothPageOpen: false
    property real disabledOpacity: 0.2

    cover: Qt.resolvedUrl("qrc:/assets/cover/CoverPage.qml")
    initialPage: Component { MeasurementList {} }
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted:
    {
        if (settings.isFirstRun)
        {
            settings.isFirstRun = false
            pageStack.push(Qt.resolvedUrl("qrc:/assets/pages/Tutorial.qml"), {}, PageStackAction.Immediate)
        }
    }

    function openAddMeasurementDialog()
    {
        var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddMeasurement.qml"))
        dialog.accepted.connect(function()
        {
            pythonGlukometr.measurements.add({
                "value": dialog.value,
                "meal": dialog.meal
            });
            if (dialog.remind)
                pythonGlukometr.reminders.remindInTwoHours()
        })
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
