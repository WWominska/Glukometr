import QtQuick 2.0
import QtQuick.Controls 2.3
import ".."
import "../components"

DialogPage
{
    id: addDrugsDialog
    property alias value: nameField.text
    property bool isEdited: false
    title: isEdited ? qsTr("ADD_DRUG_TITLE_EDIT") : qsTr("ADD_DRUG_TITLE_ADD")

    Flickable
    {
        ScrollBar.vertical: ScrollBar { }
        anchors.fill: parent
        contentWidth: parent.width

         TextField
         {
             id: nameField
             width: parent.width
             placeholderText: qsTr("DRUG_NAME_PLACEHOLDER")
             anchors
             {
                 left: parent.left
                 right: parent.right
                 top: parent.top
                 margins: Theme.horizontalPageMargin

             }
         }
    }
}
