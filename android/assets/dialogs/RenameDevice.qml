import QtQuick 2.0
import QtQuick.Controls 2.3
import ".."
import "../components"

DialogPage
{
    id: dialogDevice
    property string name;

    header: DialogHeader {id: header}
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



         SectionHeader
         {
            font.pixelSize: Theme.fontSizeLarge
            text: "Zmień nazwe"
         }

         TextField
         {
             id: nameField
             width: parent.width
             text: name
             placeholderText: "Np. Glukometr w domu"
             //label: "Twoja nazwa"
         }
    }
}
