import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: screenMonitor

    Rectangle
    {
        id: updatei
        width: parent.width
        height: 80
        anchors.bottom: stop.top
        color: "#000000"
        border.color: "#2dc4c4"
        border.width: 2

        Label
        {
            id: logi
            text: glukometr.wiadomosc
            anchors.centerIn: updatei
            color: "#2dc4c4"
        }
    }

    Image {
        id: background
        width: 300
        height: width
        anchors.centerIn: parent
        source: "glucometr.png"
        fillMode: Image.PreserveAspectFit
    }

    Button
    {
        id:stop
        width: parent.width
        height: 0.1*parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "Stop"
        color: "#209B9B"
        highlightBackgroundColor: "#2DC4C4"
        onClicked: {
            glukometr.disconnectService();
            pageLoader.source = "results.qml";
        }
    }
}
