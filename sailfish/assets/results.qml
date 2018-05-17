import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: results
    // color: "#000000"


    Component.onCompleted: pythonGlukometr.getMeasurements()


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
                height: 80
                color: "transparent"
                radius: 10
                Label
                {
                    id: wartosccukrowa
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
                    id: dataiczas
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
            MenuItem
            {
                text: "Bluetooth"
                onClicked: pageStack.push("home.qml")
            }
            MenuItem
            {
                text: "Lol"
                onClicked: pythonGlukometr.addMeasurement(120, 0, 0, 0, 2)
            }
            MenuItem
            {
                text: "Pobierz dane"
                onClicked:
                {
                    glukometr.connectToService("0"); // TODO: naprawic
                    pageStack.push("monitor.qml")
                }
            }

        }
        VerticalScrollDecorator {}


        id: ksiazka
        anchors.fill: parent
        model: pythonGlukometr.measurements  //glukometr.pomiary
        delegate: ListItem
        {
            id: pomiar
            contentHeight: sweet.height + kiedyPomiar.height + Theme.paddingSmall*3
            //height: Theme.itemSizeMedium
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
                    onClicked: pythonGlukometr.deleteMeasurement(id)
                }
            }

            GlassItem
            {
                x: 0
                id: dot
                width: Theme.itemSizeExtraSmall
                height: width
                anchors.verticalCenter: sweet.verticalCenter
                color: pythonGlukometr.evaluateMeasurement(value, meal)
            }

            Label
            {
                id: sweet
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
                id: kiedyPomiar
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                text: changeToString(meal)
                color: Theme.secondaryColor
                anchors
                {
                    top: sweet.bottom
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
                anchors.left: kiedyPomiar.right
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin
                anchors.top: parent.top
                anchors.topMargin: Theme.paddingSmall
                color: "#2dc4c4"
            }
        }
    }
}
