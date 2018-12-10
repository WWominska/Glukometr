import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: dialogDevice
    property string name;

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

         DialogHeader { id: naglowek }

         SectionHeader
         {
            font.pixelSize: Theme.fontSizeLarge
            text: qsTr("Zmień nazwe")
         }

         TextField
         {
             id: nameField
             width: parent.width
             text: name
             placeholderText: qsTr("Np. Glukometr w domu")
             label: qsTr("Twoja nazwa")
         }
    }
}
