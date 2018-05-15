import QtQuick 2.0
import Sailfish.Silica 1.0

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
            Label
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
            width: 0.75*parent.width
            height: 0.15*parent.height
            anchors.centerIn: parent
            text: "Szukaj Urządzeń"
            onClicked: pageLoader.source="home.qml"
            color: "#209B9B"
            highlightBackgroundColor: "#2DC4C4"
        }

        Button
        {
            id: costam
            width: 0.75*parent.width
            height: 0.15*parent.height
            anchors.top: call.bottom
            text: "wyniki bro"
            onClicked: pageLoader.source="results.qml"
            color: "#209B9B"
            highlightBackgroundColor: "#2DC4C4"
        }

        Button
        {
            id: costam2
            width: 0.75*parent.width
            height: 0.15*parent.height
            anchors.top: costam.bottom
            text: "lol"
            onClicked: pythonGlukometr.addMeasurement(120, 0, 0, 0, 2)
            color: "#209B9B"
            highlightBackgroundColor: "#2DC4C4"
        }
    }

    Loader
    {
        id: pageLoader
        anchors.fill: parent
    }

    GlucoseApplication {
        id: pythonGlukometr
    }
}
