import QtQuick 2.0
import QtQuick.Controls 2.3
import ".."
import "../components"

DialogPage
{
    id: dialogDevice
    property string name;

    title: qsTr("Zmień nazwę")
    canAccept: nameField.text != ""
    onDone:
    {
        if (result == DialogResult.Accepted)
        {
            name = nameField.text
        }
    }

    Column
    {
        id: column
        width: parent.width
        spacing: Theme.paddingSmall

         TextField
         {
             id: nameField
             width: parent.width
             text: name
             anchors
             {
                 left: parent.left
                 right: parent.right
                 top: parent.top
                 margins: Theme.horizontalPageMargin

             }
             placeholderText: qsTr("Np. Glukometr w domu")
             //label: "Twoja nazwa"
         }
    }
}
