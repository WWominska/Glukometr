import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: screen
    property string wiadomosc: glukometr.wiadomosc

    Connections {
        target: glukometr
        onWiadomoscChanged:
        {
            busyIndicator.running = wiadomosc == "Skanowanie urządzeń"
        }
        onNazwaChanged: busyIndicator.running = false

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

    SilicaListView {
        id: theListView
        width: parent.width
        anchors.fill: parent
        model: glukometr.nazwa

        header: PageHeader {
            title: "Wybierz urządzenie"
        }

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
                    pageStack.push("monitor.qml");
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
}
