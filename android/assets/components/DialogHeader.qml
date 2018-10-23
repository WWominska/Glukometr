import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3

ToolBar {
    width: parent.width
    property var dialog: parent
    RowLayout {
        anchors.fill: parent
        ToolButton {
            text: "Cancel"
            enabled: dialog.canCancel
            onClicked: dialog.cancel()
        }

        Item {
            Layout.fillWidth: true
        }

        ToolButton {
            text: "Accept"
            enabled: dialog.canAccept
            onClicked: dialog.accept()
        }
    }

}
