import QtQuick 2.0

Rectangle {
    id:button

    property real buttonWidth: 300
    property real buttonHeight: 80
    property string text: "Button"

    signal buttonClick()
    width: click.pressed ? (buttonWidth - 15) : buttonWidth
    height: click.pressed ? (buttonHeight - 15) :buttonHeight

    color: click.pressed ? "#2DC4C4" : "#209B9B"

    border.color: "#000000"
    border.width: 5
    radius: 10

    Text
    {
        id: label
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent
        elide: Text.ElideMiddle
        color: "#000000"
        text: button.text
    }

    MouseArea
    {
        id: click
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        onClicked: buttonClick()
    }
}
