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
        model: measurements.model
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
                text: model.value
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.leftMargin: 15
                color: "#2dc4c4"
            }

            Text
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
                font.pixelSize: 15
                text: changeToString(model.meal)
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#2dc4c4"
            }

            Text
            {
                id: data
                font.pixelSize: 15
                text: new Date(model.timestamp*1000).toLocaleString(Qt.locale("pl_PL"),"dd.MM.yy    HH:mm")
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
