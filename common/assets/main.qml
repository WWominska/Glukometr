import QtQuick 2.0

Item
{
    width: 400
    height: 600
    id: begin

    Rectangle
    {
        color: "#000000"
        anchors.fill: parent
        Rectangle
        {
            id: about
            width: parent.width
            height: 0.1*parent.height
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#000000"
            border.color: "#2dc4c4"
            border.width: 2
            radius: 10
            Text
            {
                id: aboutinfo
                anchors.centerIn: parent
                color: "#2dc4c4"
                text: "'Glucometr 3000'"
            }
        }

        Button
        {
            id:call
            buttonWidth: 0.75*parent.width
            buttonHeight: 0.15*parent.height
            anchors.centerIn: parent
            text: "Szukaj Urządzeń"
            onButtonClick: pageLoader.source="home.qml"
        }

        Button {
            anchors {
                top: call.bottom
                topMargin: 32
            }

            text: "pomiary"
            onButtonClick: {
                measurements.getFromDB();
                pageLoader.source="results.qml"
            }
        }
    }

    Loader
    {
        id: pageLoader
        anchors.fill: parent
    }
}
