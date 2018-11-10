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
            font.family: "Material Icons"
            font.pixelSize: 20
            text: pageStack.depth > 1 ? "\ue5c4" : "\ue1a7"
            onClicked: {
                if (pageStack.depth > 1)
                    pageStack.pop()
                else pageStack.push("qrc:/assets/pages/DeviceList.qml")
            }
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
            font.family: "Material Icons"
            font.pixelSize: 20
            text: "\ue8b8"
            onClicked: pageStack.push("qrc:/assets/pages/Settings.qml")
        }
    }
}
