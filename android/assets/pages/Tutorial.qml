import QtQuick 2.0
import QtQuick.Controls 2.3
import ".."
import "../components"

Page
{
    Column
    {
        id: column
        spacing: Theme.paddingMedium
        anchors
        {
            left: parent.left
            right: parent.right
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
            verticalCenter: parent.verticalCenter
        }

        Label
        {
            id: welcome
            anchors
            {
                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
            }

            text: qsTr("WELCOME_TEXT")
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
            font.pixelSize: Theme.fontSizeHuge
            color: Theme.highlightColor
            wrapMode: Text.WordWrap
        }

        Button
        {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("WELCOME_BEGIN")
            onClicked: pageStack.pop()
        }
    }
}
