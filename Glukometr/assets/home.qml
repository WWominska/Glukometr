import QtQuick 2.0

Rectangle
{
    id: screen
    color: "#000000"
    property string wiadomosc: glukometr.wiadomosc
    onWiadomoscChanged:
    {
        if (glukometr.wiadomosc != "Skanowanie urządzeń" && glukometr.wiadomosc != "Znaleziono urządzenie.")
        {
            background.visible = false;
        }
        else
        {
            background.visible = true;
        }
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

        Text
        {
            id: selectText
            color: "#2dc4c4"
            font.pixelSize: 34
            anchors.centerIn: parent
            text: "WYBIERZ URZĄDZENIE"
        }
    }

    Component.onCompleted: {
        glukometr.urzadzenieSearch();
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

            Text {
                id: urzadzenie
                font.pixelSize: 30
                text: modelData.urzadzenieNazwa
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#000000"
            }

            Text {
                id: urzadzenieAdres
                font.pixelSize: 30
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
        buttonWidth: parent.width
        buttonHeight: 0.1*parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "Menu"
        onButtonClick: pageLoader.source="main.qml"
    }
}
