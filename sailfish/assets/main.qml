import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages";

ApplicationWindow {
    id: application
    property bool isTutorialEnabled: false
    property bool measurementPageOpen: false
    property bool bluetoothPageOpen: false
    property real disabledOpacity: 0.2

    property bool lightTheme: {
        try {
            if (Theme.colorScheme !== Theme.LightOnDark)
                return true
        } catch (e) {}
        return false
    }

    cover: Qt.resolvedUrl("qrc:/assets/cover/CoverPage.qml")
    initialPage: Component { MeasurementList {} }
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted:
    {
        if (!settings.notFirstRun)
        {
            settings.notFirstRun = true
            pageStack.push(Qt.resolvedUrl("qrc:/assets/pages/Tutorial.qml"), {}, PageStackAction.Immediate)
        }
        reminders.get();
    }

    function openAddMeasurementDialog()
    {
        var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddMeasurement.qml"))
        dialog.accepted.connect(function()
        {
            measurements.add({
                "value": dialog.value,
                "meal": dialog.meal
            });
            if (dialog.remind)
                reminders.remindInTwoHours()
        })
    }
}
