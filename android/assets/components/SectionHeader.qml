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
        anchors
        {
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
            verticalCenter: parent.verticalCenter
            top: parent.top
            topMargin: Theme.horizontalPageMargin * 0.5
        }
        font.pixelSize: Theme.fontSizeSmall
        color: "#f7f5f0"
    }
}
