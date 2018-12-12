import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: results
    property var colors: [
        "#DB4F56", "#FFF757", "#1DDE4D"
    ]
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
            height: pageHeader.height + (application.datesSet ? filtersHeader.height : 0) + (chartContainer.visible ? chartContainer.height : 0)
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
            Item {
                visible: measurements.model.rowCount()
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                id: chartContainer
                width: parent.width
                height: chart.height + 2 * Theme.paddingMedium
                Column {
                    id: przepisNaPlacek
                    spacing: Theme.paddingLarge
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: Theme.paddingLarge *2
                    }
                    width: parent.width / 2

                    Row {
                        spacing: Theme.paddingMedium
                        Rectangle {
                            color: colors[0]
                            height: 14
                            width: 14
                            radius: 7
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        Label {
                            text: "Hipoglikemia"
                        }
                    }

                    Row {
                        spacing: Theme.paddingMedium
                        Rectangle {
                            color: colors[2]
                            height: 14
                            width: 14
                            radius: 7
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        Label {
                            text: "Prawidłowo"
                        }
                    }

                    Row {
                        spacing: Theme.paddingMedium
                        Rectangle {
                            color: colors[1]
                            height: 14
                            width: 14
                            radius: 7
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Label {
                            text: "Hiperglikemia"
                        }
                    }
                }

                Item {
                    id: chart
                    y: Theme.paddingMedium
                    x: parent.width / 2
                    height: 300
                    width: parent.width / 2

                    Column {
                        width: Theme.itemSizeHuge * 0.7
                        anchors.centerIn: parent
                        Text {
                            id: topLabel
                            width: parent.width
                            text: "" + measurements.model.rowCount()
                            verticalAlignment: Text.AlignBottom
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: Theme.fontSizeLarge
                            color: Theme.primaryColor
                            fontSizeMode: Text.Fit
                        }
                        Rectangle {
                            id: ruler
                            width: parent.width
                            height: Math.round(2*Theme.pixelRatio)
                            color: Theme.rgba(Theme.secondaryColor, 0.4)
                            x: 0
                        }
                        Text {
                            id: bottomLabel
                            text: {
                                if (measurements.model.rowCount() === 1) {
                                    return qsTr("pomiar");
                                } else {
                                    if (measurements.model.rowCount() <= 4) {
                                        return qsTr("pomiary");
                                    } else {
                                        return qsTr("pomiarów");
                                    }
                                }
                            }
                            width: parent.width
                            color: Theme.rgba(Theme.secondaryColor, 0.6)
                            font.pixelSize: Theme.fontSizeMedium
                            horizontalAlignment: topLabel.horizontalAlignment
                            height: topLabel.height // makes vertically centering the ruler within the surrounding circle easier
                            fontSizeMode: Text.Fit
                        }
                    }

                    Repeater {
                        id: repeater
                        model: ListModel {
                            property int total: 100
                            ListElement {
                                position: 0.0
                                bytes: 0.0
                            }
                            ListElement {
                                position: 0.0
                                bytes: 0.0
                            }
                            ListElement {
                                position: 0.0
                                bytes: 0.0
                            }
                        }
                        ProgressCircleBase {
                            backgroundColor: "transparent"
                            progressColor: colors[model.index % colors.length]
                            rotation: 360*model.position/repeater.model.total
                            value: bytes/repeater.model.total
                            anchors.centerIn: parent

                            height: width
                            width: implicitWidth
                            implicitWidth: Theme.itemSizeHuge
                            borderWidth: Math.round(Theme.paddingLarge/3)
                        }
                    }
                }
                Connections {
                    target: measurements
                    onRedChanged: {
                        repeater.model.set(0, {
                                          "bytes": measurements.red,
                                          "position" : 0
                                        })
                    }
                    onYellowChanged: {
                        repeater.model.set(1, {
                                          "bytes": measurements.yellow,
                                          "position" : measurements.red
                                        })
                    }
                    onGreenChanged: {
                        repeater.model.set(2, {
                                          "bytes": measurements.green,
                                          "position" : measurements.yellow + measurements.red
                                        })
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
