import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: addDrugsDialog
    property alias value: nameField.text
    property bool isEdited: false

    SilicaFlickable
    {
        VerticalScrollDecorator {}
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.childrenRect.height

        Column
        {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

             DialogHeader { id: header }

             SectionHeader
             {
                font.pixelSize: Theme.fontSizeLarge
                text: isEdited ? qsTr("ADD_DRUG_TITLE_EDIT") : qsTr("ADD_DRUG_TITLE_ADD")
             }

             TextField
             {
                 id: nameField
                 width: parent.width
                 placeholderText: qsTr("DRUG_NAME_PLACEHOLDER")
                 placeholderColor: Theme.highlightBackgroundColor
                 label: qsTr("ADD_DRUG_NAME_LABEL")
             }
        }
    }
}
