import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: results

    Connections {
        target: thresholds
        onModelChanged: measurements.get()
    }

    SilicaListView
    {
        opacity: hint.running ? disabledOpacity : 1.0
        Behavior on opacity { FadeAnimation {} }
        section {
            property: "date_measured"
            delegate: Rectangle
            {
                height: tekst.paintedHeight + Theme.paddingMedium
                width: parent.width
                color: application.lightTheme ? "#77ffffff" : "#77000000"
                Label
                {
                    id: tekst
                    text: section
                    color: Theme.primaryColor
                    anchors
                    {
                        left: parent.left
                        leftMargin: Theme.paddingLarge
                        verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        header: Item {
            width: parent.width
            height: pageHeader.height + (application.datesSet ? filtersHeader.height : 0)
            PageHeader {
                id: pageHeader
                title: "Pomiary"
            }
            Item {
                anchors.top: pageHeader.bottom
                id: filtersHeader
                width: parent.width
                height: Theme.itemSizeLarge
                visible: application.datesSet
                Label {
                    x: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    textFormat: Text.RichText
                    text: "Okres: <span style='color: " + Theme.secondaryColor + "'>" + application.beginDate.toLocaleDateString(Qt.locale(), "dd-MM-yyyy") + "</span> - <span style='color: " + Theme.secondaryColor + "'>" + application.endDate.toLocaleDateString(Qt.locale(), "dd-MM-yyyy") + "</span>"
                }
                IconButton {
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    icon.source: "image://Theme/icon-m-dismiss"
                    onClicked: {
                        application.datesSet = false
                        measurements.get(true)
                    }
                }
            }
        }
        PullDownMenu
        {
            id: pullDownMenu
            MenuItem
            {
                text: "Ustawienia"
                onClicked: if (!isTutorialEnabled) pageStack.push("qrc:/assets/pages/Settings.qml")
            }

            MenuItem
            {
                text: "Bluetooth"
                onClicked: if (!isTutorialEnabled) pageStack.push("qrc:/assets/pages/DeviceList.qml")
            }

            MenuItem {
                text: "Wybierz przedział"
                onClicked: if (!isTutorialEnabled) pageStack.push("qrc:/assets/pages/Calendar.qml")
            }

            MenuItem
            {
                text: "Dodaj pomiar"
                onClicked: openAddMeasurementDialog()
            }
        }
        VerticalScrollDecorator {}


        id: book
        anchors.fill: parent
        model: measurements.model
        delegate: ListItem
        {
            enabled: !isTutorialEnabled
            id: measurement
            RemorseItem { id: remorse }
            contentHeight: sugar.height + whenMeasurement.height + Theme.paddingSmall*3
            onClicked: pageStack.push(Qt.resolvedUrl("qrc:/assets/pages/MeasurementDetails.qml"), {
                                          "measurement_id": measurement_id,
                                          "value": value,
                                          "meal": meal,
                                          "timestamp": timestamp
                                      })
            menu: ContextMenu
            {
                MenuItem
                {
                    text: "Zmień pore posiłku"
                    onClicked:
                    {
                        var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/ChangeMeal.qml"),
                                                                         {"meal": meal})
                        dialog.accepted.connect(function()
                        {
                            measurements.update({
                                "measurement_id": measurement_id
                            }, {"meal": dialog.meal}, true);
                        })
                    }
                }
                MenuItem
                {
                    text: "Usuń"
                    onClicked: remorse.execute(measurement, "Usunięcie pomiaru", function() {
                        measurements.remove(measurement_id)
                    })
                }
            }

            GlassItem
            {
                x: 0
                id: dot
                width: Theme.itemSizeExtraSmall
                height: width
                anchors.verticalCenter: sugar.verticalCenter
                color: thresholds.evaluateMeasurement(value, meal)
            }

            Label
            {
                id: sugar
                font.pixelSize: Theme.fontSizeSmall
                text: value
                anchors
                {
                    left: dot.right
                    top: parent.top
                    topMargin: Theme.paddingSmall
                }
                color: Theme.primaryColor
            }

            Label
            {
                id: whenMeasurement
                font.pixelSize: Theme.fontSizeSmall
                text: application.mealListModel[meal < 0 ? 4 : meal].name
                color: Theme.secondaryColor
                anchors
                {
                    top: sugar.bottom
                    topMargin: Theme.paddingSmall
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                }
            }

            Label
            {
                id: dateLabel
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignRight
                text: new Date(timestamp*1000).toLocaleString(Qt.locale(), "HH:mm")
                anchors
                {
                    left: whenMeasurement.right
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                    top: parent.top
                    topMargin: Theme.paddingSmall
                }
                color: Theme.highlightColor
            }
        }
    }

    InteractionHintLabel
    {
        text: "Aby przejść dalej przesuń palcem w dół"
        color: Theme.secondaryColor
        anchors.top: parent.top
        opacity: hint.running ? (pullDownMenu.active ? 0.0 : 1.0) : 0.0
        Behavior on opacity { FadeAnimation {} }
        invert: true
    }

    InteractionHintLabel
    {
        text: "Wybierz 'Dodaj pomiar'"
        color: Theme.secondaryColor
        anchors.bottom: parent.bottom
        opacity: hint.running ? (pullDownMenu.active ? 1.0 : 0.0) : 0.0
        Behavior on opacity { FadeAnimation {} }
        invert: false
    }

    TouchInteractionHint
    {
        id: hint
        loops: Animation.Infinite
        interactionMode: TouchInteraction.Pull
        direction: TouchInteraction.Down
        Connections {
            target: application
            onIsTutorialEnabledChanged:
            {
                if (application.isTutorialEnabled)
                    hint.start()
                else hint.stop();
            }
        }
    }
}
