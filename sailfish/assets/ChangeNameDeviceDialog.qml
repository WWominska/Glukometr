import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: dialogDevice
    property string name;
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
            text: "Zmień nazwe"
            font.bold: true
         }

         TextField
         {
             id: nameField
             width: parent.width
             placeholderText: "Np. Glukometr w domu"
             label: "Twoja nazwa"
         }
    }
}
