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

    property var beginDate: new Date()
    property var endDate: new Date()
    property bool datesSet: false

    property var mealListModel: [
        {
            "meal": 0,
            "lightIcon": "qrc:/icons/icon-fasting-light.svg",
            "icon": "qrc:/icons/icon-fasting.svg",
            "name": qsTr("MEAL_FASTING")
        },
        {
            "meal": 1,
            "lightIcon": "qrc:/icons/icon-before-meal-light.svg",
            "icon": "qrc:/icons/icon-before-meal.svg",
            "name": qsTr("MEAL_BEFORE")
        },
        {
            "meal": 2,
            "lightIcon": "qrc:/icons/icon-after-meal-light.svg",
            "icon": "qrc:/icons/icon-after-meal.svg",
            "name": qsTr("MEAL_AFTER")
        },
        {
            "meal": 3,
            "lightIcon": "image://Theme/icon-m-night",
            "icon": "image://Theme/icon-m-night",
            "name": qsTr("MEAL_NIGHT")
        },
        {
            "meal": 4,
            "lightIcon": "image://Theme/icon-m-question",
            "icon": "image://Theme/icon-m-question",
            "name": qsTr("MEAL_UNKNOWN")
        }
    ]


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
