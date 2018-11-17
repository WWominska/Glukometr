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

    property var mealListModel: [
        {
            "meal": 0,
            "iconSource": "fasting",
            "name": qsTr("Na czczo")
        },
        {
            "meal": 1,
            "iconSource": "apple",
            "name": qsTr("Przed posiłkiem")
        },
        {
            "meal": 2,
            "iconSource": "after-meal",
            "name": qsTr("Po posiłku")
        },
        {
            "meal": 3,
            "iconSource": "night",
            "name": qsTr("Nocna")
        },
        {
            "meal": 4,
            "iconSource": "question",
            "name": qsTr("Nie określono")
        }
    ]

    FontLoader {
        id: materialFont
        name: "Material Icons"
        source: "qrc:/assets/fonts/MaterialIcons-Regular.ttf"
    }

    Shortcut {
        sequences: ["Esc", "Back"]
        enabled: pageStack.depth > 1
        onActivated: pageStack.pop()
    }

    StackView {
        id: pageStack
        initialItem: MeasurementList {}
        background: Rectangle {
            color: "black"
            anchors.fill: parent
        }

        anchors.fill: parent

        pushEnter: Transition {
            id: pushEnter
            ParallelAnimation {
                PropertyAction { property: "x"; value: pushEnter.ViewTransition.item.pos }
                NumberAnimation { properties: "y"; from: pushEnter.ViewTransition.item.pos + stackView.offset; to: pushEnter.ViewTransition.item.pos; duration: 400; easing.type: Easing.OutCubic }
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic }
            }
        }
        popExit: Transition {
            id: popExit
            ParallelAnimation {
                PropertyAction { property: "x"; value: popExit.ViewTransition.item.pos }
                NumberAnimation { properties: "y"; from: popExit.ViewTransition.item.pos; to: popExit.ViewTransition.item.pos + stackView.offset; duration: 400; easing.type: Easing.OutCubic }
                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 400; easing.type: Easing.OutCubic }
            }
        }

        pushExit: Transition {
            id: pushExit
            PropertyAction { property: "x"; value: pushExit.ViewTransition.item.pos }
            PropertyAction { property: "y"; value: pushExit.ViewTransition.item.pos }
        }
        popEnter: Transition {
            id: popEnter
            PropertyAction { property: "x"; value: popEnter.ViewTransition.item.pos }
            PropertyAction { property: "y"; value: popEnter.ViewTransition.item.pos }
        }
    }


    Component.onCompleted:
    {
        if (!settings.notFirstRun)
        {
            settings.notFirstRun = true
            pageStack.push(Qt.resolvedUrl("qrc:/assets/pages/Tutorial.qml"), {}, StackView.Immediate)
        }
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
