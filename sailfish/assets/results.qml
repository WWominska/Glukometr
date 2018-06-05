import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: results
    Component.onCompleted: pythonGlukometr.measurements.get()

    Connections {
        target: pythonGlukometr.thresholds
        onModelUpdated: pythonGlukometr.measurements.get()
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
                    font.bold: true
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
                    font.bold: true
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
            MenuItem {
                text: "Leki"
                onClicked: pageStack.push("DrugsPage.qml")
            }

            MenuItem {
                text: "Przypomnienia"
                onClicked: pageStack.push("RemindersPage.qml")
            }

            MenuItem
            {
                text: "Ustaw progi"
                onClicked: pageStack.push("Threshold.qml")
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
                Repeater {
                    model: pythonGlukometr.drugs.model
                    MenuItem { text: name }
                }

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
                font.bold: true
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
                font.bold: true
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
                font.bold: true
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
