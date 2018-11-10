import QtQuick 2.0

Rectangle {
    color: "black"
    anchors.fill: parent
    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/tuo.jpg"
        smooth: true
        opacity: 0.5
    }
}
