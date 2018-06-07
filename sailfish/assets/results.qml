import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: results
    Component.onCompleted:
    {
        console.log()
        pythonGlukometr.measurements.get()
    }

    Connections
    {
        target: pythonGlukometr.thresholds
        onModelUpdated: pythonGlukometr.measurements.get()
    }

    Item
    {
        z: 2
        anchors.fill: book
        visible: pythonGlukometr.measurements.model.count === 0
        Column
        {
            anchors.centerIn: parent
            spacing: Theme.paddingLarge
            Label
            {
                text: "Nie masz pomiaru!"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeLarge
            }

            Label
            {
                text: "Kliknij by dodać"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.secondaryColor
            }

            Button
            {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Dodaj pomiar"
                onClicked:
                {
                    var dialog = pageStack.push(Qt.resolvedUrl("AddNewMeasurement.qml"))
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
            }
        }
    }

    SilicaListView
    {
        header: Item
        {
            width: parent.width
            height: pageHeader.height + dit.height
            PageHeader
            {
                id: pageHeader
                title: "Pomiary"
            }

            Rectangle
            {
                id: dit
                visible: pythonGlukometr.measurements.model.count !== 0
                width: parent.width
                anchors
                {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                    top: pageHeader.bottom
                }
                height: sweetValue.paintedHeight + Theme.paddingMedium
                color: "transparent"

                Label
                {
                    id: sweetValue
                    font.pixelSize: Theme.fontSizeMedium
                    text: "Cukier"
                    anchors
                    {
                        left: parent.left
                        top: parent.top
                    }
                    color: Theme.primaryColor
                }

                Label
                {
                    id: dateAndTime
                    font.pixelSize: Theme.fontSizeMedium
                    horizontalAlignment: Text.AlignRight
                    text: "Data i Czas"
                    anchors
                    {
                        right: parent.right
                        top: parent.top

                        //verticalCenter: parent.verticalCenter
                    }
                    color: Theme.primaryColor
                    clip: true
                }
            }
        }
        PullDownMenu
        {
            MenuItem
            {
                text: "Ustawienia"
                onClicked: pageStack.push("Setting.qml")
            }

            MenuItem
            {
                text: "Bluetooth"
                onClicked: pageStack.push("home.qml")
            }

            MenuItem
            {
                text: "Dodaj pomiar"
                onClicked:
                {
                    var dialog = pageStack.push(Qt.resolvedUrl("AddNewMeasurement.qml"))
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
            }
        }
        VerticalScrollDecorator {}


        id: book
        anchors.fill: parent
        model: pythonGlukometr.measurements.model
        delegate: ListItem
        {
            id: measurement
            RemorseItem { id: remorse }
            contentHeight: sugar.height + whenMeasurement.height + Theme.paddingSmall*3
            onClicked: pageStack.push(Qt.resolvedUrl("MeasurementDetailsPage.qml"), {
                                          "measurement_id": id,
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
                        var dialog = pageStack.push(Qt.resolvedUrl("ChangeMealDialog.qml"),
                                                                         {"meal": meal})
                        dialog.accepted.connect(function()
                        {
                            pythonGlukometr.measurements.update(id, {
                                "meal": dialog.meal
                            })
                        })
                    }
                }
                MenuItem
                {
                    text: "Usuń"
                    onClicked: remorse.execute(measurement, "Usunięcie pomiaru", function() {
                        pythonGlukometr.measurements.remove(id)
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
                color: pythonGlukometr.evaluateMeasurement(value, meal)
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
                function changeToString(meal)
                {
                    switch(meal)
                    {
                        case 0: return "Na czczo"
                        case 1: return "Przed posiłkiem"
                        case 2: return "Po posiłku"
                        case 3: return "Nocna"
                        default: return "Nie określono"
                    }
                }
                id: whenMeasurement
                font.pixelSize: Theme.fontSizeSmall
                text: changeToString(meal)
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
                id: data
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignRight
                text: new Date(timestamp*1000).toLocaleString(Qt.locale("pl_PL"),"dd.MM.yy    HH:mm")
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
}
