import QtQuick 2.0

Rectangle
{
    id: results
    color: "#000000"
    Rectangle
    {
        id: wyniki
        width: parent.width
        anchors.top: parent.top
        height: 80
        color: "#000000"
        radius: 10
        Text
        {
            id: restText
            color: "#2dc4c4"
            font.pixelSize: 34
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
        Text
        {
            id: wartosccukrowa
            font.pixelSize: 23
            text: "Cukier [mg/dL]"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.leftMargin: 15
            color: "#2dc4c4"
        }

        Text
        {
            id: dataiczas
            font.pixelSize: 23
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

            Text
            {
                id: sweet
                font.pixelSize: 15
                text: modelData.cukier
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.leftMargin: 15
                color: "#2dc4c4"
            }

            Text
            {
                id: kiedyPomiar
                font.pixelSize: 15
                text: modelData.kiedy
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#2dc4c4"
            }

            Text
            {
                id: data
                font.pixelSize: 15
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
    buttonWidth: parent.width
    buttonHeight: 0.1*parent.height
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: start.top
    text: "Menu"
    onButtonClick: { pageLoader.source="main.qml"}
}

Button
{
    id:start
    buttonWidth: parent.width
    buttonHeight: 0.1*parent.height
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    text: "Pobierz Dane"
    onButtonClick:
    {
        glukometr.connectToService(glukometr.urzadzenieAdres());
        pageLoader.source="monitor.qml";
    }
}
}
