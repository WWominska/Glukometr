import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle
{
    id: results
    color: "#000000"
    Component.onCompleted:  glukometr.obtainResults()
    Rectangle
    {
        id: wyniki
        width: parent.width
        anchors.top: parent.top
        height: 80
        color: "#000000"
        radius: 10
        Label
        {
            id: restText
            color: "#2dc4c4"
            font.pixelSize: Theme.fontSizeHuge
            anchors.centerIn: parent
            text: "HISTORIA POMIARÓW"
        }
    }

    Rectangle
    {
        id: dit
        width: parent.width
        anchors.top: wyniki.bottom
        height: 80
        color: "#000000"
        radius: 10
        Label
        {
            id: wartosccukrowa
            font.pixelSize: Theme.fontSizeMedium
            text: "Cukier [mg/dL]"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.leftMargin: 15
            color: "#2dc4c4"
        }

        Label
        {
            id: dataiczas
            font.pixelSize: Theme.fontSizeMedium
            text: "Data i Czas"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.rightMargin: 15
            color: "#2dc4c4"
        }
    }


    ListView
    {
        id: ksiazka
        anchors
        {
            top: dit.bottom;
            left: parent.left;
            right: parent.right;
            bottom: menuLast.top;
        }
        model: glukometr.pomiary
        delegate: Rectangle
        {
            id: pomiar
            height:60
            width: parent.width
            color: "#000000"

            Label
            {
                id: sweet
                font.pixelSize: Theme.fontSizeSmall
                text: modelData.cukier
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.leftMargin: 15
                color: "#2dc4c4"
            }

            Label
            {
                id: kiedyPomiar
                font.pixelSize: Theme.fontSizeSmall
                text: modelData.kiedy
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#2dc4c4"
            }

            Label
            {
                id: data
                font.pixelSize: Theme.fontSizeSmall
                text: modelData.dataPomiaru
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.rightMargin: 15
                color: "#2dc4c4"
            }
        }
    }

Button
{
    id:menuLast
    color: "#209B9B"
    highlightBackgroundColor: "#2DC4C4"
    width: parent.width
    height: 0.1*parent.height
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: start.top
    text: "Menu"
    onClicked: { pageLoader.source="main.qml"}
}

Button
{
    id:start
    width: parent.width
    height: 0.1*parent.height
    color: "#209B9B"
    highlightBackgroundColor: "#2DC4C4"
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    text: "Pobierz Dane"
    onClicked:
    {
        glukometr.connectToService(glukometr.urzadzenieAdres());
        pageLoader.source="monitor.qml";
    }
}
}
