import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2
import QtQuick.Controls.Material 2.1
import ".."

ToolBar {
    Material.foreground: "white"
    width: parent.width
    background: Rectangle {
        color: "black"
        opacity: 0.8
    }

    //height: content.childrenRect.height + 2 * Theme.paddingMedium
    property alias title: titleLabel.text
    //property alias description: descriptionLabel.text


    RowLayout {
        spacing: 10
        anchors.fill: parent

        ToolButton {
            text: "fstecz"
            icon.name: stackView.depth > 1 ? "back" : "drawer"
            onClicked: pageStack.pop()
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

        }
    }
}
