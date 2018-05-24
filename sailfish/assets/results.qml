import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: results
    Component.onCompleted: pythonGlukometr.getMeasurements()


    SilicaListView
    {
        opacity: hint.running ? 0.5 : 1.0
        Behavior on opacity { FadeAnimation {} }
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
                height: 80
                color: "transparent"
                radius: 10
                Label
                {
                    id: sweetValue
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                    text: "Cukier"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.topMargin: 15
                    color: Theme.primaryColor
                }

                Label
                {
                    id: dateAndTime
                    font.pixelSize: Theme.fontSizeMedium
                    horizontalAlignment: Text.AlignRight
                    font.bold: true
                    text: "Data i Czas"
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: 15
                    color: Theme.primaryColor
                    clip: true
                }
            }
        }
        PullDownMenu
        {
            id: pullDownMenu
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
                text: "By sprawdzić tutorial"
                onClicked: pageStack.push("Tutorial.qml")
            }

            MenuItem
            {
                text: "Dodaj pomiar"
                onClicked:
                {
                    var dialog = pageStack.push(Qt.resolvedUrl("AddNewMeasurement.qml"))
                    dialog.accepted.connect(function()
                    {
                        pythonGlukometr.addMeasurement(dialog.value, 0, 0, 0, dialog.meal)
                    })
                }
            }

        }
        VerticalScrollDecorator {}


        id: book
        anchors.fill: parent
        model: pythonGlukometr.measurements  //glukometr.pomiary
        delegate: ListItem
        {
            id: measurement
            RemorseItem { id: remorse }
            contentHeight: sugar.height + whenMeasurement.height + Theme.paddingSmall*3
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
                            pythonGlukometr.updateMeasurement(id, dialog.meal)
                        })
                    }
                }
                MenuItem
                {
                    text: "Usuń"
                    onClicked: remorse.execute(measurement, "Usunięcie pomiaru", function() {pythonGlukometr.deleteMeasurement(id) } )
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
                anchors.left: dot.right
                anchors.top: parent.top
                anchors.topMargin: Theme.paddingSmall
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
                text: timestamp.toLocaleString(Qt.locale("pl_PL"),"dd.MM.yy    HH:mm")
                anchors.left: whenMeasurement.right
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin
                anchors.top: parent.top
                anchors.topMargin: Theme.paddingSmall
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
    }

    Connections
    {
        target: application
        onIsTutorialEnabledChanged: hint.start()
    }
}
