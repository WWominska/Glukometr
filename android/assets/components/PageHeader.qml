import QtQuick 2.0
import ".."

Item {
    width: parent.width
    height: content.childrenRect.height + 2 * Theme.paddingMedium
    property alias title: titleLabel.text
    property alias description: descriptionLabel.text

    Column {
        id: content
        anchors {
            top: parent.top
            topMargin: Theme.paddingMedium
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
        }
        Text {
            id: titleLabel
            anchors.right: parent.right
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeLarge
        }
        Text {
            id: descriptionLabel
            anchors.right: parent.right
            height: text != "" ? paintedHeight : 0
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeMedium
        }
    }
}
