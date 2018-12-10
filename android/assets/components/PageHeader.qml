import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2
import QtQuick.Controls.Material 2.1
import ".."

ToolBar {
    id: header
    Material.foreground: "white"
    width: parent.width
    background: Rectangle {
        color: "black"
        opacity: 0.8
    }

    property alias rightIcon: rightButton.text
    property var rightCallback: function () {}

    property alias leftIcon: leftButton.text
    property var leftCallback: function () {
        if (pageStack.depth > 1)
            pageStack.pop()
    }

    //height: content.childrenRect.height + 2 * Theme.paddingMedium
    property alias title: titleLabel.text
    //property alias description: descriptionLabel.text


    RowLayout {
        spacing: 10
        anchors.fill: parent

        ToolButton {
            id: leftButton
            font.family: "Material Icons"
            font.pixelSize: 20
            text: "\ue5c4"
            onClicked: leftCallback()
        }

        Label {
            id: titleLabel
            text: listView.currentItem ? listView.currentItem.text : "Gallery"
            font.pixelSize: 20
            elide: Label.ElideRight
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            Layout.fillWidth: true
        }
        ToolButton {
            id: rightButton
            font.family: "Material Icons"
            font.pixelSize: 20
            enabled: text != ""
            onClicked: header.rightCallback()
        }
    }
}
