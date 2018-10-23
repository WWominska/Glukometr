import QtQuick 2.0
import QtQuick.Controls 2.3
import ".."

Item {
    width: parent.width
    height: titleLabel.paintedHeight + 2 * Theme.paddingSmall
    property alias text: titleLabel.text
    property alias font: titleLabel.font

    Label {
        id: titleLabel
        anchors.right: parent.right
        anchors.rightMargin: Theme.horizontalPageMargin
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: Theme.fontSizeSmall
    }
}
