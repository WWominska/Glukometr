import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Window 2.11
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Universal 2.3

import "pages"

Item
{
    id: application
    width: Screen.height * 0.4
    height: Screen.height * 0.75
    Universal.theme: Universal.Dark
    Universal.accent: Universal.Blue
    Material.theme: Material.Dark
    Material.accent: Material.Blue
    property bool isTutorialEnabled: false
    property bool measurementPageOpen: false
    property bool bluetoothPageOpen: false
    property real disabledOpacity: 0.2

    Shortcut {
        sequences: ["Esc", "Back"]
        enabled: pageStack.depth > 1
        onActivated: pageStack.pop()
    }

    Item {
        id: pythonGlukometr
    }

    Item {
        id: remorse
        function execute(component, label, callback) {
            callback();
        }
    }

    StackView {
        id: pageStack
        initialItem: MeasurementList {}
        anchors.fill: parent
    }


    Component.onCompleted:
    {
        if (!settings.notFirstRun)
        {
            console.log("TODO: implement welcome page")
            // settings.notFirstRun = true
            // pageStack.push(Qt.resolvedUrl("qrc:/assets/pages/Tutorial.qml"), {}, PageStackAction.Immediate)
        }
    }

    function openAddMeasurementDialog()
    {
        var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddMeasurement.qml"))
        dialog.accepted.connect(function()
        {
            console.log(dialog.value)
            console.log(dialog.meal)
            measurements.add({
                "value": dialog.value,
                "meal": dialog.meal
            });
            if (dialog.remind)
                pythonGlukometr.reminders.remindInTwoHours()
        })
    }
}
