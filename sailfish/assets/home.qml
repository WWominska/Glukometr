import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    id: screen
    color: "#000000"
    property string wiadomosc: glukometr.wiadomosc

    Connections {
        target: glukometr
        onWiadomoscChanged:
        {
            busyIndicator.running = wiadomosc == "Skanowanie urządzeń"
        }
        onNazwaChanged: busyIndicator.running = false

    }

    Rectangle
    {
        id:select
        width: parent.width
        anchors.top: parent.top
        height: 80
        color: "#000000"
        border.color: "#000000"
        radius: 10

        Label
        {
            id: selectText
            color: "#2dc4c4"
            font.pixelSize: Theme.fontSizeLarge
            anchors.centerIn: parent
            text: "WYBIERZ URZĄDZENIE"
        }
    }

    Component.onCompleted: {
        glukometr.urzadzenieSearch();
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
        size: BusyIndicatorSize.Large

        Label {
            anchors {
                horizontalCenter: busyIndicator.horizontalCenter
                top: busyIndicator.bottom
                topMargin: Theme.paddingLarge
            }

            text: glukometr.wiadomosc
        }
    }

    ListView {
        id: theListView
        width: parent.width
        anchors.top: select.bottom
        anchors.bottom: scanAgain.top
        model: glukometr.nazwa

        delegate: Rectangle {
            id: box
            height:100
            width: parent.width
            color: "#2dc4c4"
            border.color: "#000000"
            border.width: 5
            radius: 15

            MouseArea {
                anchors.fill: parent
                onPressed: { box.color= "#209b9b"; box.height=110}
                onClicked: {
                    glukometr.connectToService(modelData.urzadzenieAdres);
                    pageLoader.source="monitor.qml";
                }
            }

            Label {
                id: urzadzenie
                font.pixelSize: Theme.fontSizeMedium
                text: modelData.urzadzenieNazwa
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#000000"
            }

            Label {
                id: urzadzenieAdres
                font.pixelSize: Theme.fontSizeTiny
                text: modelData.urzadzenieAdres
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#000000"
            }
        }
    }

    Button {
        id:scanAgain
        width: parent.width
        height: 0.1*parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "Menu"
        onClicked: pageLoader.source="main.qml"
        color: "#209B9B"
        highlightBackgroundColor: "#2DC4C4"
    }
}
